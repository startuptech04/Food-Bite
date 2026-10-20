/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/order_business_insight_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'orders_business_insight_event.dart';
part 'orders_business_insight_state.dart';

class OrdersBusinessInsightBloc extends Bloc<OrdersBusinessInsightEvent, OrdersBusinessInsightState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  OrdersBusinessInsightBloc() : super(OrdersBusinessInsightState(model: OrderBusinessInsightModel(locale: ''))) {
    on<OrdersBusinessInsightInitialEvent>(_onOrdersBusinessInsightInitialEvent);
    on<OrdersBusinessInsightUnitChangeEvent>(_onOrdersBusinessInsightUnitChangeEvent);
  }

  FutureOr<void> _onOrdersBusinessInsightInitialEvent(OrdersBusinessInsightInitialEvent event, Emitter<OrdersBusinessInsightState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "order_business_insight"}, 'order_business_insight_screen', 'order_business_insight_screen');
      emit(state.copyWith(status: OrdersBusinessInsightStatus.loading, unit: 'month'));
      DioApiResponse response = await _orderRepository.orderBusinessInsight();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderBusinessInsightModel data = OrderBusinessInsightModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: OrdersBusinessInsightStatus.success, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersBusinessInsightStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersBusinessInsightStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrdersBusinessInsightUnitChangeEvent(OrdersBusinessInsightUnitChangeEvent event, Emitter<OrdersBusinessInsightState> emit) async {
    emit(state.copyWith(unit: event.unit, status: OrdersBusinessInsightStatus.success));
  }
}
