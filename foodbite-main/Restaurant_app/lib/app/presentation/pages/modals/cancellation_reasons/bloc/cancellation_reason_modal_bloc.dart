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
import 'package:vendor/app/core/models/order_cancellation_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'cancellation_reason_modal_event.dart';
part 'cancellation_reason_modal_state.dart';

class CancellationReasonModalBloc extends Bloc<CancellationReasonModalEvent, CancellationReasonModalState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CancellationReasonModalBloc()
    : super(
        CancellationReasonModalState(
          list: OrderCancellationListModel(reasons: [], locale: ''),
        ),
      ) {
    on<CancellationReasonModalInitialEvent>(_onCancellationReasonModalInitialEvent);
    on<CancellationReasonModalSelectEvent>(_onCancellationReasonModalSelectEvent);
  }

  FutureOr<void> _onCancellationReasonModalInitialEvent(CancellationReasonModalInitialEvent event, Emitter<CancellationReasonModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "order_cancellation_reason"}, 'order_cancellation_reason_screen', 'order_cancellation_reason_screen');
      emit(state.copyWith(status: CancellationReasonModalStatus.loading));
      DioApiResponse response = await _orderRepository.getCancellationReasonList();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderCancellationListModel data = OrderCancellationListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.reasons!.isNotEmpty ? CancellationReasonModalStatus.success : CancellationReasonModalStatus.empty, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CancellationReasonModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CancellationReasonModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCancellationReasonModalSelectEvent(CancellationReasonModalSelectEvent event, Emitter<CancellationReasonModalState> emit) async {
    emit(state.copyWith(status: CancellationReasonModalStatus.success, reasonId: event.id));
  }
}
