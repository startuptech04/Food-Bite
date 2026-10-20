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
import 'package:vendor/app/core/models/request/custom_sub_category_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/sub_categories_list_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'sub_categories_event.dart';
part 'sub_categories_state.dart';

class SubCategoriesBloc extends Bloc<SubCategoriesEvent, SubCategoriesState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  SubCategoriesBloc()
    : super(
        SubCategoriesState(
          customPageSize: ApiRequestService.pageSize,
          mainPageSize: ApiRequestService.pageSize,
          categories: SubCategoriesModel(locale: ''),
        ),
      ) {
    on<SubCategoriesInitialEvent>(_onSubCategoriesInitialEvent);
    on<SubCategoriesChangeStatusEvent>(_onSubCategoriesChangeStatusEvent);
    on<SubCategoriesDeleteEvent>(_onSubCategoriesDeleteEvent);
    on<MainSubCategoriesLoadMoreEvent>(_onMainSubCategoriesLoadMoreEvent);
    on<CustomSubCategoriesLoadMoreEvent>(_onCustomSubCategoriesLoadMoreEvent);
  }

  FutureOr<void> _onSubCategoriesInitialEvent(SubCategoriesInitialEvent event, Emitter<SubCategoriesState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "custom_sub_category"}, 'custom_sub_category_list_screen', 'custom_sub_category_list_screen');
      emit(state.copyWith(status: SubCategoriesStatus.loading));
      final String vendorId = await _menuRepository.getVendorId();
      DioApiResponse response = await _menuRepository.getSubCategories(state.customPageSize, state.customCurrentPage, state.mainPageSize, state.mainCurrentPage, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        SubCategoriesModel data = SubCategoriesModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: SubCategoriesStatus.success, appLocale: locale.toString(), categories: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SubCategoriesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SubCategoriesStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSubCategoriesChangeStatusEvent(SubCategoriesChangeStatusEvent event, Emitter<SubCategoriesState> emit) async {
    state.categories.vendorCategory!.results!.firstWhere((element) => element.id == event.model.id!).status = event.status;
    emit(state.copyWith(categories: state.categories));
    try {
      CustomSubCategoryRequestModel categoryParam = CustomSubCategoryRequestModel(name: event.model.name, category: event.model.category!.id!, status: event.status, restaurant: event.model.restaurant);
      DioApiResponse response = await _menuRepository.updateCustomSubCategory(event.model.id!, categoryParam);
      if (response.errorType != NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SubCategoriesStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SubCategoriesStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSubCategoriesDeleteEvent(SubCategoriesDeleteEvent event, Emitter<SubCategoriesState> emit) async {
    try {
      emit(state.copyWith(status: SubCategoriesStatus.deleteLoaderStarted));
      DioApiResponse response = await _menuRepository.deleteCustomSubCategory(event.id);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: SubCategoriesStatus.deleteLoaderEnded));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SubCategoriesStatus.deleteLoaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SubCategoriesStatus.deleteLoaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMainSubCategoriesLoadMoreEvent(MainSubCategoriesLoadMoreEvent event, Emitter<SubCategoriesState> emit) async {
    if (state.categories.mainCategory!.results!.length < state.categories.mainCategory!.totalResults!) {
      try {
        emit(state.copyWith(customLoadMore: true));
        final String vendorId = await _menuRepository.getVendorId();
        DioApiResponse response = await _menuRepository.getSubCategories(state.customPageSize, state.customCurrentPage, state.mainPageSize * 2, state.mainCurrentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          SubCategoriesModel data = SubCategoriesModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: SubCategoriesStatus.success, categories: data, customLoadMore: false, mainPageSize: state.mainPageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: SubCategoriesStatus.failure, statusCode: data.code, customLoadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: SubCategoriesStatus.failure, customLoadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onCustomSubCategoriesLoadMoreEvent(CustomSubCategoriesLoadMoreEvent event, Emitter<SubCategoriesState> emit) async {
    if (state.categories.vendorCategory!.results!.length < state.categories.vendorCategory!.totalResults!) {
      try {
        emit(state.copyWith(customLoadMore: true));
        final String vendorId = await _menuRepository.getVendorId();
        DioApiResponse response = await _menuRepository.getSubCategories(state.customPageSize * 2, state.customCurrentPage, state.mainPageSize, state.mainCurrentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          SubCategoriesModel data = SubCategoriesModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: SubCategoriesStatus.success, categories: data, customLoadMore: false, customPageSize: state.customPageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: SubCategoriesStatus.failure, statusCode: data.code, customLoadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: SubCategoriesStatus.failure, customLoadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
