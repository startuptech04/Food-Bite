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
import 'package:vendor/app/core/models/main_sub_categories_active_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'main_sub_categories_modal_event.dart';
part 'main_sub_categories_modal_state.dart';

class MainSubCategoriesModalBloc extends Bloc<MainSubCategoriesModalEvent, MainSubCategoriesModalState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  MainSubCategoriesModalBloc() : super(MainSubCategoriesModalState(info: MainSubCategoriesListModel(locale: ''))) {
    on<MainSubCategoriesModalInitialEvent>(_onMainSubCategoriesModalInitialEvent);
    on<MainSubCategoriesSelectEvent>(_onMainSubCategoriesSelectEvent);
    on<MainSubCategoriesOnSaveEvent>(_onMainSubCategoriesOnSaveEvent);
  }

  FutureOr<void> _onMainSubCategoriesModalInitialEvent(MainSubCategoriesModalInitialEvent event, Emitter<MainSubCategoriesModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "main_sub_categories_list"}, 'main_sub_categories_list_screen', 'main_sub_categories_list_screen');
      emit(state.copyWith(status: MainSubCategoriesModalStatus.loading));
      DioApiResponse response = await _menuRepository.getSubCategoryById(event.cateId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        var categories = (jsonDecode(response.body) as List).map((value) => MainSubCategoriesListModel.fromJson(value, locale.toString())).toList();
        emit(state.copyWith(status: MainSubCategoriesModalStatus.success, categories: categories, selectedCategories: event.selectedCategories));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MainSubCategoriesModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MainSubCategoriesModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMainSubCategoriesSelectEvent(MainSubCategoriesSelectEvent event, Emitter<MainSubCategoriesModalState> emit) async {
    emit(state.copyWith(selectedCategories: event.selectedCategories.id));
  }

  FutureOr<void> _onMainSubCategoriesOnSaveEvent(MainSubCategoriesOnSaveEvent event, Emitter<MainSubCategoriesModalState> emit) async {
    var selected = state.categories.firstWhere((element) => element.id == state.selectedCategories);
    emit(state.copyWith(info: selected, status: MainSubCategoriesModalStatus.selected));
  }
}
