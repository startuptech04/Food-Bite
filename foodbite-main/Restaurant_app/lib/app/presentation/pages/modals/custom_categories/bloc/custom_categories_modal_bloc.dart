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
import 'package:vendor/app/core/models/vendor_categories_limited_info_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'custom_categories_modal_event.dart';
part 'custom_categories_modal_state.dart';

class CustomCategoriesModalBloc extends Bloc<CustomCategoriesModalEvent, CustomCategoriesModalState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CustomCategoriesModalBloc() : super(CustomCategoriesModalState(info: VendorCategoriesLimitedInfoModel(locale: ''))) {
    on<CustomCategoriesModalInitialEvent>(_onCustomCategoriesModalInitialEvent);
    on<CustomCategoriesSelectEvent>(_onCustomCategoriesSelectEvent);
    on<CustomCategoriesOnSaveEvent>(_onCustomCategoriesOnSaveEvent);
  }

  FutureOr<void> _onCustomCategoriesModalInitialEvent(CustomCategoriesModalInitialEvent event, Emitter<CustomCategoriesModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "custom_category_list"}, 'custom_category_list_screen', 'custom_category_list_screen');
      emit(state.copyWith(status: CustomCategoriesModalStatus.loading));
      final String vendorId = await _menuRepository.getVendorId();
      DioApiResponse response = await _menuRepository.getVendorCategories(vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        var categories = (jsonDecode(response.body) as List).map((value) => VendorCategoriesLimitedInfoModel.fromJson(value, locale.toString())).toList();
        emit(state.copyWith(status: CustomCategoriesModalStatus.success, categories: categories, selectedCategories: event.selectedCategories));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CustomCategoriesModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CustomCategoriesModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCustomCategoriesSelectEvent(CustomCategoriesSelectEvent event, Emitter<CustomCategoriesModalState> emit) async {
    emit(state.copyWith(selectedCategories: event.selectedCategories.id));
  }

  FutureOr<void> _onCustomCategoriesOnSaveEvent(CustomCategoriesOnSaveEvent event, Emitter<CustomCategoriesModalState> emit) async {
    var selected = state.categories.firstWhere((element) => element.id == state.selectedCategories);
    emit(state.copyWith(info: selected, status: CustomCategoriesModalStatus.selected));
  }
}
