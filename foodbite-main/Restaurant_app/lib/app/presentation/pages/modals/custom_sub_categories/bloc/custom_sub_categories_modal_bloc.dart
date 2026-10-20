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
import 'package:vendor/app/core/models/vendor_sub_categories_active_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'custom_sub_categories_modal_event.dart';
part 'custom_sub_categories_modal_state.dart';

class CustomSubCategoriesModalBloc extends Bloc<CustomSubCategoriesModalEvent, CustomSubCategoriesModalState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CustomSubCategoriesModalBloc() : super(CustomSubCategoriesModalState(info: VendorSubCategoriesListModel(locale: ''))) {
    on<CustomSubCategoriesModalInitialEvent>(_onCustomSubCategoriesModalInitialEvent);
    on<CustomSubCategoriesSelectEvent>(_onCustomSubCategoriesSelectEvent);
    on<CustomSubCategoriesOnSaveEvent>(_onCustomSubCategoriesOnSaveEvent);
  }

  FutureOr<void> _onCustomSubCategoriesModalInitialEvent(CustomSubCategoriesModalInitialEvent event, Emitter<CustomSubCategoriesModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_custom_category"}, 'add_update_custom_category_screen', 'add_update_custom_category_screen');
      emit(state.copyWith(status: CustomSubCategoriesModalStatus.loading));
      DioApiResponse response = await _menuRepository.getCustomSubCategoryById(event.cateId, event.vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        var categories = (jsonDecode(response.body) as List).map((value) => VendorSubCategoriesListModel.fromJson(value, locale.toString())).toList();
        emit(state.copyWith(status: CustomSubCategoriesModalStatus.success, categories: categories, selectedCategories: event.selectedCategories));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CustomSubCategoriesModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CustomSubCategoriesModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCustomSubCategoriesSelectEvent(CustomSubCategoriesSelectEvent event, Emitter<CustomSubCategoriesModalState> emit) async {
    emit(state.copyWith(selectedCategories: event.selectedCategories.id));
  }

  FutureOr<void> _onCustomSubCategoriesOnSaveEvent(CustomSubCategoriesOnSaveEvent event, Emitter<CustomSubCategoriesModalState> emit) async {
    var selected = state.categories.firstWhere((element) => element.id == state.selectedCategories);
    emit(state.copyWith(info: selected, status: CustomSubCategoriesModalStatus.selected));
  }
}
