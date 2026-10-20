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
import 'package:vendor/app/core/models/dining_booking_cancellation_reason_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_cancellation_reason_modal_event.dart';
part 'dining_cancellation_reason_modal_state.dart';

class DiningCancellationReasonModalBloc extends Bloc<DiningCancellationReasonModalEvent, DiningCancellationReasonModalState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningCancellationReasonModalBloc()
    : super(
        DiningCancellationReasonModalState(
          model: DiningBookingCancellationReasonListModel(reasons: [], locale: ''),
        ),
      ) {
    on<DiningCancellationReasonModalInitialEvent>(_onDiningCancellationReasonModalInitialEvent);
    on<DiningCancellationReasonModalSelectEvent>(_onDiningCancellationReasonModalSelectEvent);
  }

  FutureOr<void> _onDiningCancellationReasonModalInitialEvent(DiningCancellationReasonModalInitialEvent event, Emitter<DiningCancellationReasonModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_cancellation_reason"}, 'dining_cancellation_reason_screen', 'dining_cancellation_reason_screen');
      emit(state.copyWith(status: DiningCancellationReasonModalStatus.loading));
      DioApiResponse response = await _diningBookingRepository.getDiningBookingCancellationReason();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningBookingCancellationReasonListModel data = DiningBookingCancellationReasonListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.reasons!.isNotEmpty ? DiningCancellationReasonModalStatus.success : DiningCancellationReasonModalStatus.empty, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningCancellationReasonModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningCancellationReasonModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningCancellationReasonModalSelectEvent(DiningCancellationReasonModalSelectEvent event, Emitter<DiningCancellationReasonModalState> emit) async {
    emit(state.copyWith(status: DiningCancellationReasonModalStatus.success, reasonId: event.id));
  }
}
