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
import 'package:user/app/core/models/order_cancellation_reason_list_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:user/app/core/repositories/history_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'cancellation_reason_list_event.dart';
part 'cancellation_reason_list_state.dart';

class CancellationReasonListBloc extends Bloc<CancellationReasonListEvent, CancellationReasonListState> {
  final HistoryRepository _historyRepository = HistoryRepository();
  final AuthRepository _authRepository = AuthRepository();
  CancellationReasonListBloc()
    : super(
        CancellationReasonListState(
          list: OrderCancellationListModel(reasons: [], locale: ''),
        ),
      ) {
    on<CancellationReasonListInitalEvent>(_onCancellationReasonListInitalEvent);
    on<CancellationReasonListSelectEvent>(_onCancellationReasonListSelectEvent);
  }

  FutureOr<void> _onCancellationReasonListInitalEvent(CancellationReasonListInitalEvent event, Emitter<CancellationReasonListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "order_cancellation_reason"}, 'order_cancellation_reason_screen', 'order_cancellation_reason_screen');
      emit(state.copyWith(status: CancellationReasonListStatus.loading));
      DioApiResponse response = await _historyRepository.getCancellationReasons();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _authRepository.getLocale();
        OrderCancellationListModel data = OrderCancellationListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.reasons!.isNotEmpty ? CancellationReasonListStatus.success : CancellationReasonListStatus.empty, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CancellationReasonListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CancellationReasonListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCancellationReasonListSelectEvent(CancellationReasonListSelectEvent event, Emitter<CancellationReasonListState> emit) async {
    emit(state.copyWith(status: CancellationReasonListStatus.success, reasonId: event.id));
  }
}
