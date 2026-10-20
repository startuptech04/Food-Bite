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
import 'package:user/app/core/models/dining_booking_refund_reason_list_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:user/app/core/repositories/dining_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_booking_refund_reason_list_modal_event.dart';
part 'dining_booking_refund_reason_list_modal_state.dart';

class DiningBookingRefundReasonListModalBloc extends Bloc<DiningBookingRefundReasonListModalEvent, DiningBookingRefundReasonListModalState> {
  final DiningRepository _diningRepository = DiningRepository();
  final AuthRepository _authRepository = AuthRepository();
  DiningBookingRefundReasonListModalBloc()
    : super(
        DiningBookingRefundReasonListModalState(
          list: DiningBookingRefundReasonListModel(reasons: [], locale: ''),
        ),
      ) {
    on<DiningBookingRefundReasonListModalInitialEvent>(_onDiningBookingRefundReasonListModalInitialEvent);
    on<DiningBookingRefundReasonListModalReasonSelectEvent>(_onDiningBookingRefundReasonListModalReasonSelectEvent);
  }

  FutureOr<void> _onDiningBookingRefundReasonListModalInitialEvent(DiningBookingRefundReasonListModalInitialEvent event, Emitter<DiningBookingRefundReasonListModalState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "dining_booking_refund_reason"}, 'dining_booking_refund_reason_screen', 'dining_booking_refund_reason_screen');
      emit(state.copyWith(status: DiningBookingRefundReasonListModalStatus.loading));
      DioApiResponse response = await _diningRepository.getDiningBookingRefundReason();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _authRepository.getLocale();
        DiningBookingRefundReasonListModel data = DiningBookingRefundReasonListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.reasons!.isNotEmpty ? DiningBookingRefundReasonListModalStatus.success : DiningBookingRefundReasonListModalStatus.empty, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningBookingRefundReasonListModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningBookingRefundReasonListModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningBookingRefundReasonListModalReasonSelectEvent(DiningBookingRefundReasonListModalReasonSelectEvent event, Emitter<DiningBookingRefundReasonListModalState> emit) async {
    emit(state.copyWith(status: DiningBookingRefundReasonListModalStatus.success, reasonId: event.id));
  }
}
