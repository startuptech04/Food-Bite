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
import 'package:vendor/app/core/models/pos_order_detail_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/pos_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'pos_order_detail_event.dart';
part 'pos_order_detail_state.dart';

class PosOrderDetailBloc extends Bloc<PosOrderDetailEvent, PosOrderDetailState> {
  final PosRepository _posRepository = PosRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PosOrderDetailBloc() : super(PosOrderDetailState(model: PosOrderDetailModel(locale: ''))) {
    on<PosOrderDetailInitialEvent>(_onPosOrderDetailInitialEvent);
  }

  FutureOr<void> _onPosOrderDetailInitialEvent(PosOrderDetailInitialEvent event, Emitter<PosOrderDetailState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "pos_order_detail"}, 'pos_order_detail_screen', 'pos_order_detail_screen');
      emit(state.copyWith(status: PosOrderDetailStatus.loading, orderId: event.orderId));
      DioApiResponse response = await _posRepository.posOrderDetail(event.orderId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          final String locale = await _accountRepository.getLocale();
          PosOrderDetailModel data = PosOrderDetailModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: PosOrderDetailStatus.success, model: data));
        } else {
          emit(state.copyWith(status: PosOrderDetailStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PosOrderDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PosOrderDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
