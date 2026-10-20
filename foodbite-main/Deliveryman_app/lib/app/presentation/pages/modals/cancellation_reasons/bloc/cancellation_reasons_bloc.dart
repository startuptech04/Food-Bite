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
import 'package:driver/app/core/models/order_cancellation_list_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/new_order_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'cancellation_reasons_event.dart';
part 'cancellation_reasons_state.dart';

class CancellationReasonsBloc extends Bloc<CancellationReasonsEvent, CancellationReasonsState> {
  final NewOrderRepositry _newOrderRepositry = NewOrderRepositry();
  final AuthRepository _authRepository = AuthRepository();
  CancellationReasonsBloc()
    : super(
        CancellationReasonsState(
          list: OrderCancellationListModel(reasons: [], locale: ''),
        ),
      ) {
    on<CancellationReasonInitialEvent>(_onCancellationReasonInitialEvent);
    on<CancellationReasonSelectEvent>(_onCancellationReasonSelectEvent);
  }

  FutureOr<void> _onCancellationReasonInitialEvent(CancellationReasonInitialEvent event, Emitter<CancellationReasonsState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "order_cancellation_reason"}, 'order_cancellation_reason_screen', 'order_cancellation_reason_screen');
      emit(state.copyWith(status: CancellationReasonsStatus.loading));
      DioApiResponse response = await _newOrderRepositry.cancellationReasonList();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderCancellationListModel data = OrderCancellationListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.reasons!.isNotEmpty ? CancellationReasonsStatus.success : CancellationReasonsStatus.empty, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CancellationReasonsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CancellationReasonsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCancellationReasonSelectEvent(CancellationReasonSelectEvent event, Emitter<CancellationReasonsState> emit) async {
    emit(state.copyWith(status: CancellationReasonsStatus.success, reasonId: event.id));
  }
}
