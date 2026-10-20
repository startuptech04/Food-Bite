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
import 'package:vendor/app/core/models/guest_availability_response_model.dart';
import 'package:vendor/app/core/models/request/save_guest_availability_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_guest_count_event.dart';
part 'dining_guest_count_state.dart';

class DiningGuestCountBloc extends Bloc<DiningGuestCountEvent, DiningGuestCountState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningGuestCountBloc() : super(const DiningGuestCountState()) {
    on<DiningGuestCountInitialEvent>(_onDiningGuestCountInitialEvent);
    on<DiningGuestCountSelectEvent>(_onDiningGuestCountSelectEvent);
    on<DiningGuestCountSaveEvent>(_onDiningGuestCountSaveEvent);
  }

  FutureOr<void> _onDiningGuestCountInitialEvent(DiningGuestCountInitialEvent event, Emitter<DiningGuestCountState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_guest_count"}, 'dining_guest_count_screen', 'dining_guest_count_screen');
      emit(state.copyWith(status: DiningGuestCountStatus.loading));
      DioApiResponse response = await _diningBookingRepository.getGuestAvailability();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        GuestAvailabilityResponseModel responseModel = GuestAvailabilityResponseModel.fromJson(myMap);
        if (responseModel.success!) {
          if (responseModel.result!.guestAvailability!.isNotEmpty) {
            emit(state.copyWith(savedGuest: responseModel.result!.guestAvailability!));
          }
        }
        emit(state.copyWith(status: DiningGuestCountStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningGuestCountStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningGuestCountStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningGuestCountSelectEvent(DiningGuestCountSelectEvent event, Emitter<DiningGuestCountState> emit) async {
    if (state.savedGuest.contains(event.selectedNumber)) {
      final updatedGuestList = List<int>.from(state.savedGuest)..remove(event.selectedNumber);
      emit(state.copyWith(savedGuest: updatedGuestList, status: DiningGuestCountStatus.success));
    } else {
      final updatedGuestList = List<int>.from(state.savedGuest)..add(event.selectedNumber);
      emit(state.copyWith(savedGuest: updatedGuestList, status: DiningGuestCountStatus.success));
    }
  }

  FutureOr<void> _onDiningGuestCountSaveEvent(DiningGuestCountSaveEvent event, Emitter<DiningGuestCountState> emit) async {
    try {
      emit(state.copyWith(status: DiningGuestCountStatus.updateStart));
      state.savedGuest.sort();
      SaveGuestAvailabilityRequestModel param = SaveGuestAvailabilityRequestModel(availability: state.savedGuest.join(','));
      DioApiResponse response = await _diningBookingRepository.saveGuestAvailability(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          emit(state.copyWith(status: DiningGuestCountStatus.updateSuccess));
        } else {
          emit(state.copyWith(status: DiningGuestCountStatus.updateFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningGuestCountStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningGuestCountStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
