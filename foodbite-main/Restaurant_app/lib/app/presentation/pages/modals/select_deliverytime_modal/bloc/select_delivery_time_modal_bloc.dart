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
import 'package:vendor/app/core/validations/deliverytime_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'select_delivery_time_modal_event.dart';
part 'select_delivery_time_modal_state.dart';

class SelectDeliveryTimeModalBloc extends Bloc<SelectDeliveryTimeModalEvent, SelectDeliveryTimeModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  SelectDeliveryTimeModalBloc()
    : super(
        SelectDeliveryTimeModalState(
          time: DeliveryTimeTimeModel(label: '', value: ''),
        ),
      ) {
    on<SelectDeliveryTimeModalInitialEvent>(_onSelectDeliveryTimeModalInitialEvent);
    on<SelectDeliveryTimeModalFromChangeEvent>(_onSelectDeliveryTimeModalFromChangeEvent);
    on<SelectDeliveryTimeModalFromUnfocusedEvent>(_onSelectDeliveryTimeModalFromUnfocusedEvent);
    on<SelectDeliveryTimeModalToChangeEvent>(_onSelectDeliveryTimeModalToChangeEvent);
    on<SelectDeliveryTimeModalToUnfocusedEvent>(_onSelectDeliveryTimeModalToUnfocusedEvent);
    on<SelectDeliveryTimeChangeEvent>(_onSelectDeliveryTimeChangeEvent);
  }

  FutureOr<void> _onSelectDeliveryTimeModalInitialEvent(SelectDeliveryTimeModalInitialEvent event, Emitter<SelectDeliveryTimeModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "select_delivery_time"}, 'select_delivery_time_screen', 'select_delivery_time_screen');
      List<String> timeList = event.deliveryTime.split(' ');
      if (timeList.isNotEmpty && timeList.length == 4) {
        final String from = timeList[0];
        final String to = timeList[2];
        final String time = timeList[3];
        List<DeliveryTimeTimeModel> timeListOption = <DeliveryTimeTimeModel>[];
        timeListOption.clear();
        DeliveryTimeTimeModel min = DeliveryTimeTimeModel(label: 'dd_min', value: 'min');
        DeliveryTimeTimeModel hour = DeliveryTimeTimeModel(label: 'dd_hour', value: 'hour');
        timeListOption.add(min);
        timeListOption.add(hour);
        final int indexOfTime = timeListOption.indexWhere((element) => element.value == time);
        final fromTime = DeliveryTimeFromField.dirty(from);
        final toTime = DeliveryTimeToField.dirty(to);
        emit(
          state.copyWith(
            from: fromTime,
            to: toTime,
            time: indexOfTime != -1 ? timeListOption[indexOfTime] : timeListOption.first,
            timeList: timeListOption,
            isValid: Formz.validate([fromTime, toTime]),
            status: SelectDeliveryTimeModalStatus.fetched,
          ),
        );
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SelectDeliveryTimeModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSelectDeliveryTimeModalFromChangeEvent(SelectDeliveryTimeModalFromChangeEvent event, Emitter<SelectDeliveryTimeModalState> emit) async {
    final from = DeliveryTimeFromField.dirty(event.from);
    emit(state.copyWith(from: from.isValid ? from : DeliveryTimeFromField.pure(event.from), status: SelectDeliveryTimeModalStatus.initial, isValid: Formz.validate([from, state.to])));
  }

  FutureOr<void> _onSelectDeliveryTimeModalFromUnfocusedEvent(SelectDeliveryTimeModalFromUnfocusedEvent event, Emitter<SelectDeliveryTimeModalState> emit) async {
    final from = DeliveryTimeFromField.dirty(state.from.value);
    emit(state.copyWith(from: from, status: SelectDeliveryTimeModalStatus.initial, isValid: Formz.validate([from, state.to])));
  }

  FutureOr<void> _onSelectDeliveryTimeModalToChangeEvent(SelectDeliveryTimeModalToChangeEvent event, Emitter<SelectDeliveryTimeModalState> emit) async {
    final to = DeliveryTimeToField.dirty(event.to);
    emit(state.copyWith(to: to.isValid ? to : DeliveryTimeToField.pure(event.to), status: SelectDeliveryTimeModalStatus.initial, isValid: Formz.validate([to, state.from])));
  }

  FutureOr<void> _onSelectDeliveryTimeModalToUnfocusedEvent(SelectDeliveryTimeModalToUnfocusedEvent event, Emitter<SelectDeliveryTimeModalState> emit) async {
    final to = DeliveryTimeToField.dirty(state.to.value);
    emit(state.copyWith(to: to, status: SelectDeliveryTimeModalStatus.initial, isValid: Formz.validate([to, state.from])));
  }

  FutureOr<void> _onSelectDeliveryTimeChangeEvent(SelectDeliveryTimeChangeEvent event, Emitter<SelectDeliveryTimeModalState> emit) async {
    emit(state.copyWith(time: event.time, status: SelectDeliveryTimeModalStatus.initial));
  }
}
