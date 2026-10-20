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
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/slots_list_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'schedules_event.dart';
part 'schedules_state.dart';

class SchedulesBloc extends Bloc<SchedulesEvent, SchedulesState> {
  final AccountRepository _accountRepository = AccountRepository();
  SchedulesBloc() : super(SchedulesState(list: SlotListModel())) {
    on<SchedulesInitialEvent>(_onSchedulesInitialEvent);
    on<ScheduleAddTimeSlotEvent>(_onScheduleAddTimeSlotEvent);
    on<ScheduleDeleteTimeSlotEvent>(_onScheduleDeleteTimeSlotEvent);
    on<ScheduleEditTimeSlotEvent>(_onScheduleEditTimeSlotEvent);
    on<ScheduleSubmitEvent>(_onScheduleSubmitEvent);
  }

  FutureOr<void> _onSchedulesInitialEvent(SchedulesInitialEvent event, Emitter<SchedulesState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "schedule_restaurant_time"}, 'schedule_restaurant_time_screen', 'schedule_restaurant_time_screen');
      emit(state.copyWith(status: SchedulesStatus.loading));
      DioApiResponse response = await _accountRepository.getMySlots();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        SlotListModel data = SlotListModel.fromJson(myMap);
        emit(state.copyWith(status: SchedulesStatus.success, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SchedulesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SchedulesStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onScheduleAddTimeSlotEvent(ScheduleAddTimeSlotEvent event, Emitter<SchedulesState> emit) async {
    int index = state.list.slots![event.dayIndex].times!.indexWhere((element) => element.start == event.startTime && element.end == event.endTime);
    if (index == -1) {
      TimeSlotElement slot = TimeSlotElement(start: event.startTime, end: event.endTime);
      state.list.slots![event.dayIndex].times!.add(slot);
      state.list.slots = [...state.list.slots!];
      emit(state.copyWith(list: state.list, status: SchedulesStatus.success));
    } else {
      emit(state.copyWith(status: SchedulesStatus.customError, statusCode: 0, alertMessage: 'Slot already exist', extraMessage: ''));
    }
  }

  FutureOr<void> _onScheduleDeleteTimeSlotEvent(ScheduleDeleteTimeSlotEvent event, Emitter<SchedulesState> emit) async {
    state.list.slots![event.dayIndex].times!.removeAt(event.slotIndex);
    state.list.slots = [...state.list.slots!];
    emit(state.copyWith(list: state.list, status: SchedulesStatus.success));
  }

  FutureOr<void> _onScheduleEditTimeSlotEvent(ScheduleEditTimeSlotEvent event, Emitter<SchedulesState> emit) async {
    int index = state.list.slots![event.dayIndex].times!.indexWhere((element) => element.start == event.startTime && element.end == event.endTime);
    if (index == -1) {
      TimeSlotElement slot = TimeSlotElement(start: event.startTime, end: event.endTime);
      state.list.slots![event.dayIndex].times![event.slotIndex] = slot;
      state.list.slots = [...state.list.slots!];
      emit(state.copyWith(list: state.list, status: SchedulesStatus.success));
    } else {
      emit(state.copyWith(status: SchedulesStatus.customError, statusCode: 0, alertMessage: 'Slot already exist', extraMessage: ''));
    }
  }

  FutureOr<void> _onScheduleSubmitEvent(ScheduleSubmitEvent event, Emitter<SchedulesState> emit) async {
    try {
      emit(state.copyWith(status: SchedulesStatus.updateStart));
      DioApiResponse response = await _accountRepository.updateMySlots(state.list.slots!);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: SchedulesStatus.updateSuccess));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SchedulesStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SchedulesStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
