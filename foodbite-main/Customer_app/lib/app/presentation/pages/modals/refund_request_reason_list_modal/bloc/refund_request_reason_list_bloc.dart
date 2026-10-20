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
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/models/refund_request_list_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:user/app/core/repositories/history_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'refund_request_reason_list_event.dart';
part 'refund_request_reason_list_state.dart';

class RefundRequestReasonListBloc extends Bloc<RefundRequestReasonListEvent, RefundRequestReasonListState> {
  final HistoryRepository _historyRepository = HistoryRepository();
  final AuthRepository _authRepository = AuthRepository();
  RefundRequestReasonListBloc()
    : super(
        RefundRequestReasonListState(
          list: RefundRequestListModel(reasons: [], locale: ''),
        ),
      ) {
    on<RefundRequestReasonListInitialEvent>(_onRefundRequestReasonListInitialEvent);
    on<RefundRequestReasonSelectEvent>(_onRefundRequestReasonSelectEvent);
  }

  FutureOr<void> _onRefundRequestReasonListInitialEvent(RefundRequestReasonListInitialEvent event, Emitter<RefundRequestReasonListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "order_refund_reason"}, 'order_refund_reason_screen', 'order_refund_reason_screen');
      emit(state.copyWith(status: RefundRequestReasonListStatus.loading));
      DioApiResponse response = await _historyRepository.getRefundReasonList();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _authRepository.getLocale();
        RefundRequestListModel data = RefundRequestListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.reasons!.isNotEmpty ? RefundRequestReasonListStatus.success : RefundRequestReasonListStatus.empty, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RefundRequestReasonListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RefundRequestReasonListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRefundRequestReasonSelectEvent(RefundRequestReasonSelectEvent event, Emitter<RefundRequestReasonListState> emit) async {
    emit(state.copyWith(status: RefundRequestReasonListStatus.success, reasonId: event.id));
  }
}
