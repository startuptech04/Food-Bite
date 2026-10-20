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
import 'package:vendor/app/core/models/dining_schedule_meal_type_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/dining_schedule_time_slot_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dialog_dining_schedule_modal_event.dart';
part 'dialog_dining_schedule_modal_state.dart';

class DialogDiningScheduleModalBloc extends Bloc<DialogDiningScheduleModalEvent, DialogDiningScheduleModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  DialogDiningScheduleModalBloc()
    : super(
        DialogDiningScheduleModalState(
          type: DiningScheduleMealTypeModel(label: '', value: ''),
        ),
      ) {
    on<DialogDiningScheduleModalInitialEvent>(_onDialogDiningScheduleModalInitialEvent);
    on<DialogDiningScheduleTypeChangeEvent>(_onDialogDiningScheduleTypeChangeEvent);
    on<DialogDiningScheduleTimePickerChanged>(_onDialogDiningScheduleTimePickerChanged);
    on<DialogDiningScheduleTimePickerUnfocused>(_onDialogDiningScheduleTimePickerUnfocused);
    on<DialogDiningScheduleModalSubmitEvent>(_onDialogDiningScheduleModalSubmitEvent);
  }

  FutureOr<void> _onDialogDiningScheduleModalInitialEvent(DialogDiningScheduleModalInitialEvent event, Emitter<DialogDiningScheduleModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "dining_schedule_time_dialog"}, 'dining_schedule_time_dialog_screen', 'dining_schedule_time_dialog_screen');
    List<DiningScheduleMealTypeModel> scheduleTimeList = <DiningScheduleMealTypeModel>[];
    scheduleTimeList.clear();
    DiningScheduleMealTypeModel breakfast = DiningScheduleMealTypeModel(label: 'dd_breakfast', value: 'breakfast');
    DiningScheduleMealTypeModel lunch = DiningScheduleMealTypeModel(label: 'dd_lunch', value: 'lunch');
    DiningScheduleMealTypeModel dinner = DiningScheduleMealTypeModel(label: 'dd_dinner', value: 'dinner');
    scheduleTimeList.add(breakfast);
    scheduleTimeList.add(lunch);
    scheduleTimeList.add(dinner);
    if (!event.isNew) {
      final time = DiningScheduleTimeField.dirty(event.time);
      final DiningScheduleMealTypeModel selected = scheduleTimeList.firstWhere((element) => element.value == event.type);
      emit(state.copyWith(time: time, type: selected, typeList: scheduleTimeList, status: DialogDiningScheduleModalStatus.initial, isValid: Formz.validate([time])));
    } else {
      emit(state.copyWith(type: scheduleTimeList.first, status: DialogDiningScheduleModalStatus.initial));
      emit(state.copyWith(typeList: scheduleTimeList, status: DialogDiningScheduleModalStatus.initial));
    }
  }

  FutureOr<void> _onDialogDiningScheduleTypeChangeEvent(DialogDiningScheduleTypeChangeEvent event, Emitter<DialogDiningScheduleModalState> emit) async {
    emit(state.copyWith(type: event.type));
  }

  FutureOr<void> _onDialogDiningScheduleTimePickerChanged(DialogDiningScheduleTimePickerChanged event, Emitter<DialogDiningScheduleModalState> emit) async {
    final time = DiningScheduleTimeField.dirty(event.time);
    emit(state.copyWith(time: time.isValid ? time : DiningScheduleTimeField.pure(event.time), status: DialogDiningScheduleModalStatus.initial, isValid: Formz.validate([time])));
  }

  FutureOr<void> _onDialogDiningScheduleTimePickerUnfocused(DialogDiningScheduleTimePickerUnfocused event, Emitter<DialogDiningScheduleModalState> emit) async {
    final time = DiningScheduleTimeField.dirty(state.time.value);
    emit(state.copyWith(time: time, status: DialogDiningScheduleModalStatus.initial, isValid: Formz.validate([time])));
  }

  FutureOr<void> _onDialogDiningScheduleModalSubmitEvent(DialogDiningScheduleModalSubmitEvent event, Emitter<DialogDiningScheduleModalState> emit) async {
    try {
      final time = DiningScheduleTimeField.dirty(state.time.value);
      emit(state.copyWith(time: time, status: DialogDiningScheduleModalStatus.initial, isValid: Formz.validate([time])));
      if (state.isValid && state.time.value.isNotEmpty) {
        emit(state.copyWith(status: DialogDiningScheduleModalStatus.success));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DialogDiningScheduleModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
