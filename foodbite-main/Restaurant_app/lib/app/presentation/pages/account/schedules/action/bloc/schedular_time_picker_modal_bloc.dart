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

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:formz/formz.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/schedule_time_slot_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'schedular_time_picker_modal_event.dart';
part 'schedular_time_picker_modal_state.dart';

class SchedularTimePickerModalBloc extends Bloc<SchedularTimePickerModalEvent, SchedularTimePickerModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  SchedularTimePickerModalBloc() : super(const SchedularTimePickerModalState()) {
    on<SchedularTimePickerInitialEvent>(_onSchedularTimePickerInitialEvent);
    on<StartTimePickerChanged>(_onStartTimePickerChanged);
    on<StartTimePickerUnfocused>(_onStartTimePickerUnfocused);
    on<EndTimePickerChanged>(_onEndTimePickerChanged);
    on<EndTimePickerUnfocused>(_onEndTimePickerUnfocused);
    on<ScheduleFormSubmitted>(_onScheduleFormSubmitted);
  }

  FutureOr<void> _onSchedularTimePickerInitialEvent(SchedularTimePickerInitialEvent event, Emitter<SchedularTimePickerModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "schedule_restaurant_time_dialog"}, 'schedule_restaurant_time_dialog_screen', 'schedule_restaurant_time_dialog_screen');
    if (!event.isNew) {
      final startTime = StartTimeField.dirty(event.startTime);
      final endTime = EndTimeField.dirty(event.endTime);
      emit(state.copyWith(startTime: startTime, endTime: endTime, status: SchedularTimePickerModalStatus.initial, isValid: Formz.validate([startTime, endTime])));
    }
  }

  FutureOr<void> _onStartTimePickerChanged(StartTimePickerChanged event, Emitter<SchedularTimePickerModalState> emit) async {
    final startTime = StartTimeField.dirty(event.time);
    emit(state.copyWith(startTime: startTime.isValid ? startTime : StartTimeField.pure(event.time), status: SchedularTimePickerModalStatus.initial, isValid: Formz.validate([startTime, state.endTime])));
  }

  FutureOr<void> _onStartTimePickerUnfocused(StartTimePickerUnfocused event, Emitter<SchedularTimePickerModalState> emit) async {
    final startTime = StartTimeField.dirty(state.startTime.value);
    emit(state.copyWith(startTime: startTime, status: SchedularTimePickerModalStatus.initial, isValid: Formz.validate([startTime, state.endTime])));
  }

  FutureOr<void> _onEndTimePickerChanged(EndTimePickerChanged event, Emitter<SchedularTimePickerModalState> emit) async {
    final endTime = EndTimeField.dirty(event.time);
    emit(state.copyWith(endTime: endTime.isValid ? endTime : EndTimeField.pure(event.time), status: SchedularTimePickerModalStatus.initial, isValid: Formz.validate([endTime, state.startTime])));
  }

  FutureOr<void> _onEndTimePickerUnfocused(EndTimePickerUnfocused event, Emitter<SchedularTimePickerModalState> emit) async {
    final endTime = EndTimeField.dirty(state.endTime.value);
    emit(state.copyWith(endTime: endTime, status: SchedularTimePickerModalStatus.initial, isValid: Formz.validate([endTime, state.startTime])));
  }

  FutureOr<void> _onScheduleFormSubmitted(ScheduleFormSubmitted event, Emitter<SchedularTimePickerModalState> emit) async {
    try {
      final startTime = StartTimeField.dirty(state.startTime.value);
      final endTime = EndTimeField.dirty(state.endTime.value);
      emit(state.copyWith(startTime: startTime, endTime: endTime, status: SchedularTimePickerModalStatus.initial, isValid: Formz.validate([startTime, endTime])));
      if (state.isValid && state.startTime.value.isNotEmpty && state.endTime.value.isNotEmpty) {
        emit(state.copyWith(status: SchedularTimePickerModalStatus.success));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SchedularTimePickerModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
