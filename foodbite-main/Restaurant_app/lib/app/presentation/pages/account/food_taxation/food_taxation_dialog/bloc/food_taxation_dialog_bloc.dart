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
import 'package:vendor/app/core/models/request/food_taxation_dialog_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/food_taxation_form_translation.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:vendor/app/core/validations/food_taxation_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_taxation_dialog_event.dart';
part 'food_taxation_dialog_state.dart';

class FoodTaxationDialogBloc extends Bloc<FoodTaxationDialogEvent, FoodTaxationDialogState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  FoodTaxationDialogBloc() : super(const FoodTaxationDialogState()) {
    on<FoodTaxationDialogInitialEvent>(_onFoodTaxationDialogInitialEvent);
    on<FoodTaxationDialogNameChangedEvent>(_onFoodTaxationDialogNameChangedEvent);
    on<FoodTaxationDialogNameUnfocusedEvent>(_onFoodTaxationDialogNameUnfocusedEvent);
    on<FoodTaxationDialogPriceChangedEvent>(_onFoodTaxationDialogPriceChangedEvent);
    on<FoodTaxationDialogPriceUnfocusedEvent>(_onFoodTaxationDialogPriceUnfocusedEvent);
    on<FoodTaxationDialogSubmitEvent>(_onFoodTaxationDialogSubmitEvent);
  }

  FutureOr<void> _onFoodTaxationDialogInitialEvent(FoodTaxationDialogInitialEvent event, Emitter<FoodTaxationDialogState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_food_taxation"}, 'add_update_food_taxation_screen', 'add_update_food_taxation_screen');
      final name = FoodTaxationNameField.pure(event.name);
      final amount = FoodTaxationAmountField.pure(event.amount.toString());
      emit(state.copyWith(name: name, amount: amount, taxId: event.taxId, isNew: event.isNew, isValid: Formz.validate([name, amount]), status: FoodTaxationDialogStatus.loaded));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodTaxationDialogStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodTaxationDialogNameChangedEvent(FoodTaxationDialogNameChangedEvent event, Emitter<FoodTaxationDialogState> emit) async {
    final name = FoodTaxationNameField.dirty(event.name);
    emit(state.copyWith(name: name.isValid ? name : FoodTaxationNameField.pure(event.name), status: FoodTaxationDialogStatus.initial, isValid: Formz.validate([name, state.amount])));
  }

  FutureOr<void> _onFoodTaxationDialogNameUnfocusedEvent(FoodTaxationDialogNameUnfocusedEvent event, Emitter<FoodTaxationDialogState> emit) async {
    final name = FoodTaxationNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: FoodTaxationDialogStatus.initial, isValid: Formz.validate([name, state.amount])));
  }

  FutureOr<void> _onFoodTaxationDialogPriceChangedEvent(FoodTaxationDialogPriceChangedEvent event, Emitter<FoodTaxationDialogState> emit) async {
    final amount = FoodTaxationAmountField.dirty(event.amount);
    emit(state.copyWith(amount: amount.isValid ? amount : FoodTaxationAmountField.pure(event.amount), status: FoodTaxationDialogStatus.initial, isValid: Formz.validate([amount, state.name])));
  }

  FutureOr<void> _onFoodTaxationDialogPriceUnfocusedEvent(FoodTaxationDialogPriceUnfocusedEvent event, Emitter<FoodTaxationDialogState> emit) async {
    final amount = FoodTaxationAmountField.dirty(state.amount.value);
    emit(state.copyWith(amount: amount, status: FoodTaxationDialogStatus.initial, isValid: Formz.validate([amount, state.name])));
  }

  FutureOr<void> _onFoodTaxationDialogSubmitEvent(FoodTaxationDialogSubmitEvent event, Emitter<FoodTaxationDialogState> emit) async {
    final name = FoodTaxationNameField.dirty(state.name.value);
    final amount = FoodTaxationAmountField.dirty(state.amount.value);
    emit(state.copyWith(name: name, amount: amount, status: FoodTaxationDialogStatus.initial, isValid: Formz.validate([name, amount])));
    if (state.isValid && state.name.value.isNotEmpty && state.amount.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: FoodTaxationDialogStatus.inProgress));

        final String vendorId = await _menuRepository.getVendorId();

        if (state.isNew) {
          FoodTaxationDialogRequestModel param = FoodTaxationDialogRequestModel(
            restaurant: vendorId,
            taxName: state.name.value.toString(),
            taxAmount: state.amount.value.toString().isNotEmpty ? double.parse(state.amount.value.toString()) : 0,
            translation: event.translations,
          );
          DioApiResponse response = await _menuRepository.saveFoodTaxation(vendorId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: FoodTaxationDialogStatus.success));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: FoodTaxationDialogStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          FoodTaxationDialogRequestModel param = FoodTaxationDialogRequestModel(
            restaurant: vendorId,
            taxName: state.name.value.toString(),
            taxAmount: state.amount.value.toString().isNotEmpty ? double.parse(state.amount.value.toString()) : 0,
            translation: event.translations,
          );
          DioApiResponse response = await _menuRepository.updateFoodTaxation(state.taxId, vendorId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: FoodTaxationDialogStatus.success));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: FoodTaxationDialogStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FoodTaxationDialogStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
