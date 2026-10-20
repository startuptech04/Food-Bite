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
import 'package:vendor/app/core/models/request/custom_sub_category_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';

import 'package:vendor/app/core/models/sub_categories_list_model.dart';
import 'package:vendor/app/core/models/translations/custom_sub_category_form_translation.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:vendor/app/core/validations/sub_custom_category_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'sub_categories_action_event.dart';
part 'sub_categories_action_state.dart';

class SubCategoriesActionBloc extends Bloc<SubCategoriesActionEvent, SubCategoriesActionState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  SubCategoriesActionBloc() : super(const SubCategoriesActionState()) {
    on<SubCategoriesActionInitialEvent>(_onSubCategoriesActionInitialEvent);
    on<CustomSubCategoryActionNameChanged>(_onCustomSubCategoryActionNameChanged);
    on<CustomSubCategoryCateIdUnfocused>(_onCustomSubCategoryCateIdUnfocused);
    on<CustomSubCategoryActionNameUnfocused>(_onCustomSubCategoryActionNameUnfocused);
    on<CustomSubCategoryActionFormCreateSubmitted>(_onCustomSubCategoryActionFormCreateSubmitted);
    on<CustomSubCategoryActionFormUpdateSubmitted>(_onCustomSubCategoryActionFormUpdateSubmitted);
    on<CustomSubCategoryActionCategoryModalResponseEvent>(_onCustomSubCategoryActionCategoryModalResponseEvent);
  }

  FutureOr<void> _onSubCategoriesActionInitialEvent(SubCategoriesActionInitialEvent event, Emitter<SubCategoriesActionState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_custom_sub_category"}, 'add_update_custom_sub_category_screen', 'add_update_custom_sub_category_screen');
    if (!event.isNew) {
      emit(
        state.copyWith(
          name: CustomSubCategoryNameField.pure(event.model.realName!),
          category: CustomSubCategoryCateIdField.pure(event.model.category != null && event.model.category!.id!.isNotEmpty ? event.model.category!.id! : ''),
          categoryName: event.model.category != null && event.model.category!.name!.isNotEmpty ? event.model.category!.name! : '',
          isValid: Formz.validate([state.name, state.category]),
        ),
      );
    }
  }

  FutureOr<void> _onCustomSubCategoryActionNameChanged(CustomSubCategoryActionNameChanged event, Emitter<SubCategoriesActionState> emit) async {
    final name = CustomSubCategoryNameField.dirty(event.name);
    emit(state.copyWith(name: name.isValid ? name : CustomSubCategoryNameField.pure(event.name), isValid: Formz.validate([name, state.category])));
  }

  FutureOr<void> _onCustomSubCategoryCateIdUnfocused(CustomSubCategoryCateIdUnfocused event, Emitter<SubCategoriesActionState> emit) async {
    final category = CustomSubCategoryCateIdField.dirty(state.category.value);
    emit(state.copyWith(category: category, isValid: Formz.validate([category, state.name])));
  }

  FutureOr<void> _onCustomSubCategoryActionNameUnfocused(CustomSubCategoryActionNameUnfocused event, Emitter<SubCategoriesActionState> emit) async {
    final name = CustomSubCategoryNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, isValid: Formz.validate([name, state.category])));
  }

  FutureOr<void> _onCustomSubCategoryActionFormCreateSubmitted(CustomSubCategoryActionFormCreateSubmitted event, Emitter<SubCategoriesActionState> emit) async {
    final name = CustomSubCategoryNameField.dirty(state.name.value);
    final category = CustomSubCategoryCateIdField.dirty(state.category.value);
    emit(state.copyWith(name: name, category: category, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name])));
    if (state.isValid && state.name.value.isNotEmpty && state.category.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        final String vendorId = await _menuRepository.getVendorId();
        CustomSubCategoryRequestModel categoryParam = CustomSubCategoryRequestModel(name: state.name.value, category: state.category.value, status: true, restaurant: vendorId, translations: event.translations);
        DioApiResponse response = await _menuRepository.createCustomSubCategory(categoryParam);
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

  FutureOr<void> _onCustomSubCategoryActionFormUpdateSubmitted(CustomSubCategoryActionFormUpdateSubmitted event, Emitter<SubCategoriesActionState> emit) async {
    final name = CustomSubCategoryNameField.dirty(state.name.value);
    final category = CustomSubCategoryCateIdField.dirty(state.category.value);
    emit(state.copyWith(name: name, category: category, status: FormzSubmissionStatus.initial, isValid: Formz.validate([name])));
    if (state.isValid && state.name.value.isNotEmpty && state.category.value.isNotEmpty) {
      try {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        final String vendorId = await _menuRepository.getVendorId();
        CustomSubCategoryRequestModel categoryParam = CustomSubCategoryRequestModel(name: state.name.value, category: state.category.value, status: event.model.status, restaurant: vendorId, translations: event.translations);
        DioApiResponse response = await _menuRepository.updateCustomSubCategory(event.model.id!, categoryParam);
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

  FutureOr<void> _onCustomSubCategoryActionCategoryModalResponseEvent(CustomSubCategoryActionCategoryModalResponseEvent event, Emitter<SubCategoriesActionState> emit) async {
    final category = CustomSubCategoryCateIdField.dirty(event.id);
    emit(state.copyWith(category: category.isValid ? category : CustomSubCategoryCateIdField.pure(event.id), isValid: Formz.validate([category, state.name])));
  }
}
