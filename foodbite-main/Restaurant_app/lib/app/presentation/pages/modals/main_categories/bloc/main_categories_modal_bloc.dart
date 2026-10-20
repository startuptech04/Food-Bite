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
import 'package:vendor/app/core/models/main_categories_active_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'main_categories_modal_event.dart';
part 'main_categories_modal_state.dart';

class MainCategoriesModalBloc extends Bloc<MainCategoriesModalEvent, MainCategoriesModalState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  MainCategoriesModalBloc() : super(MainCategoriesModalState(info: MainCategoryListModel(locale: ''))) {
    on<MainCategoriesModalInitialEvent>(_onMainCategoriesModalInitialEvent);
    on<MainCategoriesSelectEvent>(_onMainCategoriesSelectEvent);
    on<MainCategoriesOnSaveEvent>(_onMainCategoriesOnSaveEvent);
  }

  FutureOr<void> _onMainCategoriesModalInitialEvent(MainCategoriesModalInitialEvent event, Emitter<MainCategoriesModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "main_categories_list"}, 'main_categories_list_screen', 'main_categories_list_screen');
      emit(state.copyWith(status: MainCategoriesModalStatus.loading));
      DioApiResponse response = await _menuRepository.getAllMainCategory();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        var categories = (jsonDecode(response.body) as List).map((value) => MainCategoryListModel.fromJson(value, locale.toString())).toList();
        emit(state.copyWith(status: MainCategoriesModalStatus.success, categories: categories, selectedCategories: event.selectedCategories));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MainCategoriesModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MainCategoriesModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMainCategoriesSelectEvent(MainCategoriesSelectEvent event, Emitter<MainCategoriesModalState> emit) async {
    emit(state.copyWith(selectedCategories: event.selectedCategories.id));
  }

  FutureOr<void> _onMainCategoriesOnSaveEvent(MainCategoriesOnSaveEvent event, Emitter<MainCategoriesModalState> emit) async {
    var selected = state.categories.firstWhere((element) => element.id == state.selectedCategories);
    emit(state.copyWith(info: selected, status: MainCategoriesModalStatus.selected));
  }
}
