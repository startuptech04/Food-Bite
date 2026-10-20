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
import 'package:formz/formz.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/custom_pos_date_business_insight_model.dart';
import 'package:vendor/app/core/models/request/custom_date_insight_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:vendor/app/core/validations/custom_date_insight_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'custom_pos_date_insight_event.dart';
part 'custom_pos_date_insight_state.dart';

class CustomPosDateInsightBloc extends Bloc<CustomPosDateInsightEvent, CustomPosDateInsightState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CustomPosDateInsightBloc()
    : super(
        CustomPosDateInsightState(
          model: PosCustomDateBusinessInsightModel(chartData: [], trendingFoods: [], success: false, locale: ''),
        ),
      ) {
    on<CustomPosDateInsightInitialEvent>(_onCustomPosDateInsightInitialEvent);
    on<CustomPosDateInsightStartDateChangedEvent>(_onCustomPosDateInsightStartDateChangedEvent);
    on<CustomPosDateInsightStartDateUnfocusedEvent>(_onCustomPosDateInsightStartDateUnfocusedEvent);
    on<CustomPosDateInsightEndDateChangedEvent>(_onCustomPosDateInsightEndDateChangedEvent);
    on<CustomPosDateInsightEndDateUnfocusedEvent>(_onCustomPosDateInsightEndDateUnfocusedEvent);
    on<CustomPosDateInsightDateSubmitEvent>(_onCustomPosDateInsightDateSubmitEvent);
  }

  FutureOr<void> _onCustomPosDateInsightInitialEvent(CustomPosDateInsightInitialEvent event, Emitter<CustomPosDateInsightState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "custom_pos_order_date_insight"}, 'custom_pos_order_date_insight_screen', 'custom_pos_order_date_insight_screen');
  }

  FutureOr<void> _onCustomPosDateInsightStartDateChangedEvent(CustomPosDateInsightStartDateChangedEvent event, Emitter<CustomPosDateInsightState> emit) async {
    final startDate = CustomDateInsightStartDateField.dirty(event.date);
    emit(state.copyWith(startDate: startDate.isValid ? startDate : CustomDateInsightStartDateField.pure(event.date), status: CustomPosDateInsightStatus.initial, isValid: Formz.validate([startDate, state.endDate])));
  }

  FutureOr<void> _onCustomPosDateInsightStartDateUnfocusedEvent(CustomPosDateInsightStartDateUnfocusedEvent event, Emitter<CustomPosDateInsightState> emit) async {
    final startDate = CustomDateInsightStartDateField.dirty(state.startDate.value);
    emit(state.copyWith(startDate: startDate, status: CustomPosDateInsightStatus.initial, isValid: Formz.validate([startDate, state.endDate])));
  }

  FutureOr<void> _onCustomPosDateInsightEndDateChangedEvent(CustomPosDateInsightEndDateChangedEvent event, Emitter<CustomPosDateInsightState> emit) async {
    final endDate = CustomDateInsightEndDateField.dirty(event.date);
    emit(state.copyWith(endDate: endDate.isValid ? endDate : CustomDateInsightEndDateField.pure(event.date), status: CustomPosDateInsightStatus.initial, isValid: Formz.validate([state.startDate, endDate])));
  }

  FutureOr<void> _onCustomPosDateInsightEndDateUnfocusedEvent(CustomPosDateInsightEndDateUnfocusedEvent event, Emitter<CustomPosDateInsightState> emit) async {
    final endDate = CustomDateInsightEndDateField.dirty(state.endDate.value);
    emit(state.copyWith(endDate: endDate, status: CustomPosDateInsightStatus.initial, isValid: Formz.validate([state.startDate, endDate])));
  }

  FutureOr<void> _onCustomPosDateInsightDateSubmitEvent(CustomPosDateInsightDateSubmitEvent event, Emitter<CustomPosDateInsightState> emit) async {
    final startDate = CustomDateInsightStartDateField.dirty(state.startDate.value);
    final endDate = CustomDateInsightEndDateField.dirty(state.endDate.value);
    emit(state.copyWith(startDate: startDate, endDate: endDate, status: CustomPosDateInsightStatus.initial, isValid: Formz.validate([startDate, endDate])));
    if (state.isValid && state.startDate.value.isNotEmpty && state.endDate.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: CustomPosDateInsightStatus.loading));
        CustomDateInsightRequestModel param = CustomDateInsightRequestModel(vendor: await _orderRepository.getVendorId(), startDate: state.startDate.value.toString(), endDate: state.endDate.value.toString());
        DioApiResponse response = await _orderRepository.posBusinessInsightCustom(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          PosCustomDateBusinessInsightModel data = PosCustomDateBusinessInsightModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: data.trendingFoods!.isEmpty ? CustomPosDateInsightStatus.empty : CustomPosDateInsightStatus.success, model: data));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: CustomPosDateInsightStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: CustomPosDateInsightStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
