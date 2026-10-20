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
import 'package:vendor/app/core/models/categories_list_model.dart';
import 'package:vendor/app/core/models/request/custom_category_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/translations/custom_category_form_translation.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:vendor/app/core/validations/custom_category_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'categories_action_event.dart';
part 'categories_action_state.dart';

class CategoriesActionBloc extends Bloc<CategoriesActionEvent, CategoriesActionState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CategoriesActionBloc() : super(const CategoriesActionState()) {
    on<CategoriesActionInitialEvent>(_onCategoriesActionInitialEvent);
    on<CustomCategoryActionNameChanged>(_onCustomCategoryActionNameChanged);
    on<CustomCategoryActionNameUnfocused>(_onCustomCategoryActionNameUnfocused);
    on<CustomCategoryActionImageChanged>(_onCustomCategoryActionImageChanged);
    on<CustomCategoryActionFormCreateSubmitted>(_onCustomCategoryActionFormCreateSubmitted);
    on<CustomCategoryActionFormUpdateSubmitted>(_onCustomCategoryActionFormUpdateSubmitted);
  }

  FutureOr<void> _onCategoriesActionInitialEvent(CategoriesActionInitialEvent event, Emitter<CategoriesActionState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_food_categories"}, 'add_update_food_categories_screen', 'add_update_food_categories_screen');
    if (!event.isNew) {
      emit(state.copyWith(name: CustomCategoryNameField.pure(event.model.realName!), image: CustomCategoryImageField.pure(event.model.image.toString()), isValid: Formz.validate([state.name, state.image])));
    }
  }

  FutureOr<void> _onCustomCategoryActionNameChanged(CustomCategoryActionNameChanged event, Emitter<CategoriesActionState> emit) async {
    final name = CustomCategoryNameField.dirty(event.name);
    emit(state.copyWith(name: name.isValid ? name : CustomCategoryNameField.pure(event.name), status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, state.image])));
  }

  FutureOr<void> _onCustomCategoryActionNameUnfocused(CustomCategoryActionNameUnfocused event, Emitter<CategoriesActionState> emit) async {
    final name = CustomCategoryNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, state.image])));
  }

  FutureOr<void> _onCustomCategoryActionImageChanged(CustomCategoryActionImageChanged event, Emitter<CategoriesActionState> emit) async {
    final image = CustomCategoryImageField.dirty(event.image);
    emit(state.copyWith(image: image.isValid ? image : CustomCategoryImageField.pure(event.image), status: FormzSubmissionStatus.initial, isValid: Formz.validate([image, state.name])));
  }

  FutureOr<void> _onCustomCategoryActionFormCreateSubmitted(CustomCategoryActionFormCreateSubmitted event, Emitter<CategoriesActionState> emit) async {
    final name = CustomCategoryNameField.dirty(state.name.value);
    final image = CustomCategoryImageField.dirty(state.image.value);
    emit(state.copyWith(name: name, image: image, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, image])));
    if (state.isValid && state.name.value.isNotEmpty && state.image.value.isNotEmpty) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final String vendorId = await _menuRepository.getVendorId();
        CustomCategoryRequestModel categoryParam = CustomCategoryRequestModel(name: state.name.value, image: state.image.value, status: true, restaurant: vendorId, translations: event.translations);
        DioApiResponse response = await _menuRepository.createCustomCategory(categoryParam);
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

  FutureOr<void> _onCustomCategoryActionFormUpdateSubmitted(CustomCategoryActionFormUpdateSubmitted event, Emitter<CategoriesActionState> emit) async {
    final name = CustomCategoryNameField.dirty(state.name.value);
    final image = CustomCategoryImageField.dirty(state.image.value);
    emit(state.copyWith(name: name, image: image, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name, image])));
    if (state.isValid && state.name.value.isNotEmpty && state.image.value.isNotEmpty) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final String vendorId = await _menuRepository.getVendorId();
        CustomCategoryRequestModel categoryParam = CustomCategoryRequestModel(name: state.name.value, image: state.image.value, status: event.model.status, restaurant: vendorId, translations: event.translations);
        DioApiResponse response = await _menuRepository.updateCustomCategory(event.id, categoryParam);
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
