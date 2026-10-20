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
import 'package:vendor/app/core/models/addons_list_model.dart';
import 'package:vendor/app/core/models/request/addon_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/addons_form_translation.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:vendor/app/core/validations/addons_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'addon_action_event.dart';
part 'addon_action_state.dart';

class AddonActionBloc extends Bloc<AddonActionEvent, AddonActionState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  AddonActionBloc() : super(const AddonActionState()) {
    on<AddonActionInitialEvent>(_onAddonActionInitialEvent);
    on<AddonActionNameChanged>(_onAddonActionNameChanged);
    on<AddonActionNameUnfocused>(_onAddonActionNameUnfocused);
    on<AddonActionPriceChanged>(_onAddonActionPriceChanged);
    on<AddonActionPriceUnfocused>(_onAddonActionPriceUnfocused);
    on<AddonActionStockChangeEvent>(_onAddonActionStockChangeEvent);
    on<AddonActionStockNumberChangedEvent>(_onAddonActionStockNumberChangedEvent);
    on<AddonActionStockNumberUnfocused>(_onAddonActionStockNumberUnfocused);
    on<AddonActionFormCreateSubmitted>(_onAddonActionFormCreateSubmitted);
    on<AddonActionFormUpdateSubmitted>(_onAddonActionFormUpdateSubmitted);
  }

  FutureOr<void> _onAddonActionInitialEvent(AddonActionInitialEvent event, Emitter<AddonActionState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_food_addons"}, 'add_update_food_addons_screen', 'add_update_food_addons_screen');
    if (!event.isNew) {
      emit(
        state.copyWith(
          name: AddonNameField.pure(event.model.realName!),
          price: AddonPriceField.pure(event.model.price.toString()),
          stockNumber: AddonStockField.pure(event.model.stockNumber!.toString()),
          stockType: event.model.stockType!,
          isValid: Formz.validate([state.name, state.price, state.stockNumber]),
        ),
      );
    } else {
      const stockNumber = AddonStockField.dirty('-1');
      emit(state.copyWith(stockType: 'unlimited', stockNumber: stockNumber, status: FormzSubmissionStatus.initial));
    }
  }

  FutureOr<void> _onAddonActionNameChanged(AddonActionNameChanged event, Emitter<AddonActionState> emit) async {
    final name = AddonNameField.dirty(event.name);
    emit(state.copyWith(name: name.isValid ? name : AddonNameField.pure(event.name), status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, state.price, state.stockNumber])));
  }

  FutureOr<void> _onAddonActionNameUnfocused(AddonActionNameUnfocused event, Emitter<AddonActionState> emit) async {
    final name = AddonNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, state.price, state.stockNumber])));
  }

  FutureOr<void> _onAddonActionPriceChanged(AddonActionPriceChanged event, Emitter<AddonActionState> emit) async {
    final price = AddonPriceField.dirty(event.price);
    emit(state.copyWith(price: price.isValid ? price : AddonPriceField.pure(event.price), status: FormzSubmissionStatus.initial, isValid: Formz.validate([price, state.name, state.stockNumber])));
  }

  FutureOr<void> _onAddonActionPriceUnfocused(AddonActionPriceUnfocused event, Emitter<AddonActionState> emit) async {
    final price = AddonPriceField.dirty(state.price.value);
    emit(state.copyWith(price: price, status: FormzSubmissionStatus.initial, isValid: Formz.validate([price, state.name, state.stockNumber])));
  }

  FutureOr<void> _onAddonActionStockChangeEvent(AddonActionStockChangeEvent event, Emitter<AddonActionState> emit) async {
    emit(state.copyWith(stockType: event.type, status: FormzSubmissionStatus.initial));
    if (event.type == 'unlimited') {
      const stockNumber = AddonStockField.dirty('-1');
      emit(state.copyWith(stockNumber: stockNumber, status: FormzSubmissionStatus.initial, isValid: Formz.validate([stockNumber, state.name, state.price])));
    } else {
      const stockNumber = AddonStockField.dirty('');
      emit(state.copyWith(stockNumber: stockNumber, status: FormzSubmissionStatus.initial, isValid: Formz.validate([stockNumber, state.name, state.price])));
    }
  }

  FutureOr<void> _onAddonActionStockNumberChangedEvent(AddonActionStockNumberChangedEvent event, Emitter<AddonActionState> emit) async {
    final stockNumber = AddonStockField.dirty(event.value);
    emit(state.copyWith(stockNumber: stockNumber.isValid ? stockNumber : AddonStockField.pure(event.value), status: FormzSubmissionStatus.initial, isValid: Formz.validate([stockNumber, state.name, state.price])));
  }

  FutureOr<void> _onAddonActionStockNumberUnfocused(AddonActionStockNumberUnfocused event, Emitter<AddonActionState> emit) async {
    final stockNumber = AddonStockField.dirty(state.stockNumber.value);
    emit(state.copyWith(stockNumber: stockNumber, status: FormzSubmissionStatus.initial, isValid: Formz.validate([stockNumber, state.name, state.price])));
  }

  FutureOr<void> _onAddonActionFormCreateSubmitted(AddonActionFormCreateSubmitted event, Emitter<AddonActionState> emit) async {
    final name = AddonNameField.dirty(state.name.value);
    final price = AddonPriceField.dirty(state.price.value);
    final stockNumber = AddonStockField.dirty(state.stockNumber.value);
    emit(state.copyWith(name: name, price: price, stockNumber: stockNumber, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, price, stockNumber])));
    if (state.isValid && state.name.value.isNotEmpty && state.price.value.isNotEmpty && state.stockNumber.value.isNotEmpty) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        String? vendorId = await _menuRepository.getVendorId();
        AddonsRequestModel param = AddonsRequestModel(
          name: state.name.value,
          price: state.price.value,
          restaurant: vendorId,
          stockType: state.stockType,
          stockNumber: stockNumber.value.isNotEmpty ? int.parse(state.stockNumber.value.toString()) : -1,
          inStock: true,
          translations: event.translations,
        );
        DioApiResponse response = await _menuRepository.saveAddon(param);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: FormzSubmissionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onAddonActionFormUpdateSubmitted(AddonActionFormUpdateSubmitted event, Emitter<AddonActionState> emit) async {
    final name = AddonNameField.dirty(state.name.value);
    final price = AddonPriceField.dirty(state.price.value);
    final stockNumber = AddonStockField.dirty(state.stockNumber.value);
    emit(state.copyWith(name: name, price: price, stockNumber: stockNumber, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, price, stockNumber])));
    if (state.isValid && state.name.value.isNotEmpty && state.price.value.isNotEmpty && state.stockNumber.value.isNotEmpty) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final String vendorId = await _menuRepository.getVendorId();
        AddonsRequestModel param = AddonsRequestModel(
          name: state.name.value,
          price: state.price.value,
          restaurant: vendorId,
          stockType: state.stockType,
          stockNumber: stockNumber.value.isNotEmpty ? int.parse(state.stockNumber.value.toString()) : -1,
          translations: event.translations,
          status: event.model.status,
          inStock: event.model.inStock,
        );
        DioApiResponse response = await _menuRepository.updateAddon(event.id, param);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: FormzSubmissionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
