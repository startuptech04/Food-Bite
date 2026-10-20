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
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/table_order_business_insight_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_orders_business_insight_event.dart';
part 'table_orders_business_insight_state.dart';

class TableOrdersBusinessInsightBloc extends Bloc<TableOrdersBusinessInsightEvent, TableOrdersBusinessInsightState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TableOrdersBusinessInsightBloc() : super(TableOrdersBusinessInsightState(model: TableOrderBusinessInsightModel(locale: ''))) {
    on<TableOrdersBusinessInsightInitialEvent>(_onTableOrdersBusinessInsightInitialEvent);
    on<TableOrdersBusinessInsightUnitChangeEvent>(_onTableOrdersBusinessInsightUnitChangeEvent);
  }

  FutureOr<void> _onTableOrdersBusinessInsightInitialEvent(TableOrdersBusinessInsightInitialEvent event, Emitter<TableOrdersBusinessInsightState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "table_order_business_insight"}, 'table_order_business_insight_screen', 'table_order_business_insight_screen');
      emit(state.copyWith(status: TableOrdersBusinessInsightStatus.loading, unit: 'month'));
      DioApiResponse response = await _orderRepository.tableOrderBusinessInsight();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TableOrderBusinessInsightModel data = TableOrderBusinessInsightModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: TableOrdersBusinessInsightStatus.success, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrdersBusinessInsightStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrdersBusinessInsightStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrdersBusinessInsightUnitChangeEvent(TableOrdersBusinessInsightUnitChangeEvent event, Emitter<TableOrdersBusinessInsightState> emit) async {
    emit(state.copyWith(unit: event.unit, status: TableOrdersBusinessInsightStatus.success));
  }
}
