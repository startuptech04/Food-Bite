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
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/models/api_status_response_model.dart';
import 'package:driver/app/core/models/order_detail_response_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/feeds_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'completed_order_detail_event.dart';
part 'completed_order_detail_state.dart';

class CompletedOrderDetailBloc extends Bloc<CompletedOrderDetailEvent, CompletedOrderDetailState> {
  final FeedsRepository _feedsRepository = FeedsRepository();
  final AuthRepository _authRepository = AuthRepository();
  CompletedOrderDetailBloc() : super(CompletedOrderDetailState(orderDetail: OrderDetailResponseModel(locale: ''))) {
    on<CompletedOrderDetailInitialEvent>(_onCompletedOrderDetailInitialEvent);
  }

  FutureOr<void> _onCompletedOrderDetailInitialEvent(CompletedOrderDetailInitialEvent event, Emitter<CompletedOrderDetailState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "completed_order_detail"}, 'completed_order_detail_screen', 'completed_order_detail_screen');
      emit(state.copyWith(orderId: event.id, orderNo: event.orderNo));
      DioApiResponse response = await _feedsRepository.getOrderDetails(event.id);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          final String locale = await _authRepository.getLocale();
          OrderDetailResponseModel data = OrderDetailResponseModel.fromJson(myMap, locale.toString());
          data.details!.deliveryFullAddress = '${data.details!.deliveryAddressRaw!.flatHouse!} ${data.details!.deliveryAddressRaw!.locality!} ${data.details!.deliveryAddressRaw!.landmark!}';
          emit(state.copyWith(orderDetail: data, status: CompletedOrderDetailStatus.success));
        } else {
          emit(state.copyWith(status: CompletedOrderDetailStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CompletedOrderDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CompletedOrderDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
