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
import 'package:vendor/app/core/models/dining_schedule_response_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_schedule_event.dart';
part 'dining_schedule_state.dart';

class DiningScheduleBloc extends Bloc<DiningScheduleEvent, DiningScheduleState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningScheduleBloc() : super(DiningScheduleState(list: DiningScheduleResponseModel(slots: [], success: false))) {
    on<DiningScheduleInitialEvent>(_onDiningScheduleInitialEvent);
    on<DiningScheduleAddTimeSlotEvent>(_onDiningScheduleAddTimeSlotEvent);
    on<DiningScheduleDeleteTimeSlotEvent>(_onDiningScheduleDeleteTimeSlotEvent);
    on<DiningScheduleEditTimeSlotEvent>(_onDiningScheduleEditTimeSlotEvent);
    on<DiningScheduleSaveEvent>(_onDiningScheduleSaveEvent);
  }

  FutureOr<void> _onDiningScheduleInitialEvent(DiningScheduleInitialEvent event, Emitter<DiningScheduleState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_schedule_time_slot"}, 'dining_schedule_time_slot_screen', 'dining_schedule_time_slot_screen');
      emit(state.copyWith(status: DiningScheduleStatus.loading));
      DioApiResponse response = await _diningBookingRepository.getMyDiningSchedule();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningScheduleResponseModel data = DiningScheduleResponseModel.fromJson(myMap);
        emit(state.copyWith(status: DiningScheduleStatus.success, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningScheduleStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningScheduleStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningScheduleAddTimeSlotEvent(DiningScheduleAddTimeSlotEvent event, Emitter<DiningScheduleState> emit) async {
    int index = state.list.slots![event.dayIndex].times!.indexWhere((element) => element.time == event.time && element.type == event.type);
    if (index == -1) {
      TimeSlotConfigModel slot = TimeSlotConfigModel(time: event.time, type: event.type);
      state.list.slots![event.dayIndex].times!.add(slot);
      state.list.slots = [...state.list.slots!];
      emit(state.copyWith(list: state.list, status: DiningScheduleStatus.success));
    } else {
      emit(state.copyWith(status: DiningScheduleStatus.customError, statusCode: 0, alertMessage: 'Slot already exist', extraMessage: ''));
    }
  }

  FutureOr<void> _onDiningScheduleDeleteTimeSlotEvent(DiningScheduleDeleteTimeSlotEvent event, Emitter<DiningScheduleState> emit) async {
    state.list.slots![event.slotIndex].times!.removeAt(event.mealIndex);
    state.list.slots = [...state.list.slots!];
    emit(state.copyWith(list: state.list, status: DiningScheduleStatus.success));
  }

  FutureOr<void> _onDiningScheduleEditTimeSlotEvent(DiningScheduleEditTimeSlotEvent event, Emitter<DiningScheduleState> emit) async {
    int index = state.list.slots![event.slotIndex].times!.indexWhere((element) => element.time == event.time && element.type == event.type);
    if (index == -1) {
      TimeSlotConfigModel slot = TimeSlotConfigModel(time: event.time, type: event.type);
      state.list.slots![event.slotIndex].times![event.mealIndex] = slot;
      state.list.slots = [...state.list.slots!];
      emit(state.copyWith(list: state.list, status: DiningScheduleStatus.success));
    } else {
      emit(state.copyWith(status: DiningScheduleStatus.customError, statusCode: 0, alertMessage: 'Slot already exist', extraMessage: ''));
    }
  }

  FutureOr<void> _onDiningScheduleSaveEvent(DiningScheduleSaveEvent event, Emitter<DiningScheduleState> emit) async {
    try {
      emit(state.copyWith(status: DiningScheduleStatus.updateStart));
      DioApiResponse response = await _diningBookingRepository.saveDiningSchedule(state.list.slots!);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: DiningScheduleStatus.updateSuccess));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningScheduleStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningScheduleStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
