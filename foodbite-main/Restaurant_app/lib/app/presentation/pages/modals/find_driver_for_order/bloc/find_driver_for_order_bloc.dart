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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/fetch_driver_near_order_response_model.dart';
import 'package:vendor/app/core/models/request/asssign_driver_order_manually_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'find_driver_for_order_event.dart';
part 'find_driver_for_order_state.dart';

class FindDriverForOrderBloc extends Bloc<FindDriverForOrderEvent, FindDriverForOrderState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  FindDriverForOrderBloc()
    : super(
        FindDriverForOrderState(
          model: FetchDriverNearToOrderResponseModel(drivers: [], findMode: '', success: false),
        ),
      ) {
    on<FindDriverForOrderInitialEvent>(_onFindDriverForOrderInitialEvent);
    on<FindDriverForOrderSelectDriverEvent>(_onFindDriverForOrderSelectDriverEvent);
    on<FindDriverForOrderAssignEvent>(_onFindDriverForOrderAssignEvent);
  }

  FutureOr<void> _onFindDriverForOrderInitialEvent(FindDriverForOrderInitialEvent event, Emitter<FindDriverForOrderState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "find_deliveryman"}, 'find_deliveryman_screen', 'find_deliveryman_screen');
      emit(state.copyWith(status: FindDriverForOrderStatus.loading, orderId: event.orderId));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.fetchDriverNearToOrder(event.orderId, vendorId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FetchDriverNearToOrderResponseModel data = FetchDriverNearToOrderResponseModel.fromJson(myMap);
        emit(state.copyWith(status: data.drivers!.isNotEmpty ? FindDriverForOrderStatus.success : FindDriverForOrderStatus.empty, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FindDriverForOrderStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FindDriverForOrderStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFindDriverForOrderSelectDriverEvent(FindDriverForOrderSelectDriverEvent event, Emitter<FindDriverForOrderState> emit) async {
    emit(state.copyWith(selectedDriver: event.driver, status: FindDriverForOrderStatus.success));
  }

  FutureOr<void> _onFindDriverForOrderAssignEvent(FindDriverForOrderAssignEvent event, Emitter<FindDriverForOrderState> emit) async {
    try {
      emit(state.copyWith(status: FindDriverForOrderStatus.assign));
      AssignOrderToDriverManuallyRequestModel param = AssignOrderToDriverManuallyRequestModel(id: state.orderId, driver: state.selectedDriver);
      DioApiResponse response = await _orderRepository.assignDriverToOrderManually(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(status: FindDriverForOrderStatus.assignSuccess));
        } else {
          emit(state.copyWith(status: FindDriverForOrderStatus.assignFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FindDriverForOrderStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FindDriverForOrderStatus.assignFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
