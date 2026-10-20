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
import 'package:vendor/app/core/models/categories_list_model.dart';
import 'package:vendor/app/core/models/request/custom_category_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CategoriesBloc()
    : super(
        CategoriesState(
          categories: CategoriesModel(locale: ''),
          customPageSize: ApiRequestService.pageSize,
          mainPageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<CategoriesInitialEvent>(_onCategoriesInitialEvent);
    on<CategoriesChangeStatusEvent>(_onCategoriesChangeStatusEvent);
    on<CategoriesDeleteEvent>(_onCategoriesDeleteEvent);
    on<MainCategoriesLoadMoreEvent>(_onMainCategoriesLoadMoreEvent);
    on<CustomCategoriesLoadMoreEvent>(_onCustomCategoriesLoadMoreEvent);
  }

  FutureOr<void> _onCategoriesInitialEvent(CategoriesInitialEvent event, Emitter<CategoriesState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "food_categories"}, 'food_categories_screen', 'food_categories_screen');
      emit(state.copyWith(status: CategoriesStatus.loading));
      final String vendorId = await _menuRepository.getVendorId();
      DioApiResponse response = await _menuRepository.getCategories(state.customPageSize, state.customCurrentPage, state.mainPageSize, state.mainCurrentPage, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        CategoriesModel data = CategoriesModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: CategoriesStatus.success, appLocale: locale.toString(), categories: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CategoriesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CategoriesStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCategoriesChangeStatusEvent(CategoriesChangeStatusEvent event, Emitter<CategoriesState> emit) async {
    state.categories.vendorCategory!.results!.firstWhere((element) => element.id == event.id).status = event.status;
    emit(state.copyWith(categories: state.categories));
    try {
      CustomCategoryRequestModel categoryParam = CustomCategoryRequestModel(name: event.model.name, image: event.model.image, status: event.status, restaurant: event.model.restaurant);
      DioApiResponse response = await _menuRepository.updateCustomCategory(event.id, categoryParam);
      if (response.errorType != NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CategoriesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CategoriesStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCategoriesDeleteEvent(CategoriesDeleteEvent event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.deleteLoaderStarted));
    try {
      DioApiResponse response = await _menuRepository.deleteCustomCategory(event.id);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: CategoriesStatus.deleteLoaderEnded));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CategoriesStatus.deleteLoaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CategoriesStatus.deleteLoaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMainCategoriesLoadMoreEvent(MainCategoriesLoadMoreEvent event, Emitter<CategoriesState> emit) async {
    if (state.categories.mainCategory!.results!.length < state.categories.mainCategory!.totalResults!) {
      try {
        emit(state.copyWith(customLoadMore: true));
        final String vendorId = await _menuRepository.getVendorId();
        DioApiResponse response = await _menuRepository.getCategories(state.customPageSize, state.customCurrentPage, state.mainPageSize * 2, state.mainCurrentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          CategoriesModel data = CategoriesModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: CategoriesStatus.success, customLoadMore: false, categories: data, mainPageSize: state.mainPageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: CategoriesStatus.failure, statusCode: data.code, customLoadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: CategoriesStatus.failure, customLoadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onCustomCategoriesLoadMoreEvent(CustomCategoriesLoadMoreEvent event, Emitter<CategoriesState> emit) async {
    if (state.categories.vendorCategory!.results!.length < state.categories.vendorCategory!.totalResults!) {
      try {
        emit(state.copyWith(customLoadMore: true));
        final String vendorId = await _menuRepository.getVendorId();
        DioApiResponse response = await _menuRepository.getCategories(state.customPageSize * 2, state.customCurrentPage, state.mainPageSize, state.mainCurrentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          CategoriesModel data = CategoriesModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: CategoriesStatus.success, customLoadMore: false, categories: data, customPageSize: state.customPageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: CategoriesStatus.failure, statusCode: data.code, customLoadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: CategoriesStatus.failure, customLoadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
