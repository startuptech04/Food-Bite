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
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/models/api_status_response_model.dart';
import 'package:kitchen/app/core/models/order_detail_response_model.dart';
import 'package:kitchen/app/core/models/server_error_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/repositories/order_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();
  OrderDetailBloc() : super(OrderDetailState(model: OrderDetailResponseModel(success: false, locale: ''))) {
    on<OrderDetailInitialEvent>(_onOrderDetailInitialEvent);
    on<OrderDetailPrepareOrderEvent>(_onOrderDetailPrepareOrderEvent);
    on<OrderDetailCompleteOrderEvent>(_onOrderDetailCompleteOrderEvent);
  }

  FutureOr<void> _onOrderDetailInitialEvent(OrderDetailInitialEvent event, Emitter<OrderDetailState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "order_detail"}, 'order_detail_screen', 'order_detail_screen');
      emit(state.copyWith(status: OrderDetailStatus.loading, orderId: event.id));
      DioApiResponse response = await _orderRepository.orderDetail(event.id);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          OrderDetailResponseModel data = OrderDetailResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: OrderDetailStatus.success, model: data));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailPrepareOrderEvent(OrderDetailPrepareOrderEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.acceptOrder));
      DioApiResponse response = await _orderRepository.prepareOrder(state.model.detail!.id!);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: OrderDetailStatus.acceptOrderSuccess));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderDetailCompleteOrderEvent(OrderDetailCompleteOrderEvent event, Emitter<OrderDetailState> emit) async {
    try {
      emit(state.copyWith(status: OrderDetailStatus.completeOrder));
      DioApiResponse response = await _orderRepository.completeOrder(state.model.detail!.id!);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: OrderDetailStatus.completeOrderSuccess));
        } else {
          emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderDetailStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
