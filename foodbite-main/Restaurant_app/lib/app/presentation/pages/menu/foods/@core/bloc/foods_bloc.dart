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
import 'package:vendor/app/core/models/food_list_model.dart';
import 'package:vendor/app/core/models/custom_tabs_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'foods_event.dart';
part 'foods_state.dart';

class FoodsBloc extends Bloc<FoodsEvent, FoodsState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  FoodsBloc() : super(FoodsState(list: FoodListModel(locale: ''))) {
    on<FoodsInitialEvent>(_onFoodsInitialEvent);
    on<FoodsTabChangeEvent>(_onFoodsTabChangeEvent);
    on<FoodsUpdateRecommendEvent>(_onFoodsUpdateRecommendEvent);
    on<FoodsUpdateStockEvent>(_onFoodsUpdateStockEvent);
    on<FoodsToggleCustomCategoryViewEvent>(_onFoodsToggleCustomCategoryViewEvent);
    on<FoodsToggleMainCategoryViewEvent>(_onFoodsToggleMainCategoryViewEvent);
  }

  FutureOr<void> _onFoodsInitialEvent(FoodsInitialEvent event, Emitter<FoodsState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "food_items"}, 'food_item_list_screen', 'food_item_list_screen');
      final String vendorId = await _menuRepository.getVendorId();
      emit(state.copyWith(status: FoodsStatus.loading));
      DioApiResponse response = await _menuRepository.getAllFoodList(vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FoodListModel data = FoodListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel all = CustomTabListModel(label: 'All (##dynamic##)', key: 'all', countNumber: data.count![0].all!);
        CustomTabListModel reject = CustomTabListModel(label: 'Item Rejected (##dynamic##)', key: 'reject', countNumber: data.count![0].reject!);
        CustomTabListModel hold = CustomTabListModel(label: 'On Hold (##dynamic##)', key: 'hold', countNumber: data.count![0].hold!);
        CustomTabListModel photoreject = CustomTabListModel(label: 'Photo Rejected (##dynamic##)', key: 'photoreject', countNumber: data.count![0].photoreject!);
        CustomTabListModel qualityreject = CustomTabListModel(label: 'Quality Rejected (##dynamic##)', key: 'qualityreject', countNumber: data.count![0].qualityreject!);
        CustomTabListModel sizereject = CustomTabListModel(label: 'Size Rejected (##dynamic##)', key: 'sizereject', countNumber: data.count![0].sizereject!);
        CustomTabListModel hide = CustomTabListModel(label: 'Hidden (##dynamic##)', key: 'hide', countNumber: data.count![0].hide!);
        tabsList.add(all);
        tabsList.add(reject);
        tabsList.add(hold);
        tabsList.add(photoreject);
        tabsList.add(qualityreject);
        tabsList.add(sizereject);
        tabsList.add(hide);
        emit(state.copyWith(status: FoodsStatus.success, list: data, tabList: tabsList, activeTab: 'all'));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodsTabChangeEvent(FoodsTabChangeEvent event, Emitter<FoodsState> emit) async {
    emit(state.copyWith(activeTab: event.key));
    if (event.key != 'all') {
      List<FoodModel> newFoodList = <FoodModel>[];
      emit(state.copyWith(foodList: [...newFoodList]));
      List<FoodModel> filterList = <FoodModel>[];
      for (var list in state.list.custom!) {
        for (var food in list.foods!) {
          if (food.status == event.key) {
            filterList.add(food);
          }
        }
      }
      for (var list in state.list.main!) {
        for (var food in list.foods!) {
          if (food.status == event.key) {
            filterList.add(food);
          }
        }
      }
      emit(state.copyWith(foodList: [...filterList]));
    }
  }

  FutureOr<void> _onFoodsUpdateRecommendEvent(FoodsUpdateRecommendEvent event, Emitter<FoodsState> emit) async {
    if (event.listFrom == 'main') {
      state.list.main![event.categoryIndex].foods!.firstWhere((element) => element.id == event.id).recommended = event.status;
      emit(state.copyWith(list: state.list));
    } else if (event.listFrom == 'custom') {
      state.list.custom![event.categoryIndex].foods!.firstWhere((element) => element.id == event.id).recommended = event.status;
      emit(state.copyWith(list: state.list));
    } else if (event.listFrom == 'otherTabs') {
      state.foodList.firstWhere((element) => element.id == event.id).recommended = event.status;
      emit(state.copyWith(foodList: state.foodList));
    }

    try {
      DioApiResponse response = await _menuRepository.updateFoodMetaInfo(event.id, {'recommended': event.status});
      if (response.errorType != NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodsUpdateStockEvent(FoodsUpdateStockEvent event, Emitter<FoodsState> emit) async {
    if (event.listFrom == 'main') {
      state.list.main![event.categoryIndex].foods!.firstWhere((element) => element.id == event.id).inStock = event.status;
      emit(state.copyWith(list: state.list));
    } else if (event.listFrom == 'custom') {
      state.list.custom![event.categoryIndex].foods!.firstWhere((element) => element.id == event.id).inStock = event.status;
      emit(state.copyWith(list: state.list));
    } else if (event.listFrom == 'otherTabs') {
      state.foodList.firstWhere((element) => element.id == event.id).inStock = event.status;
      emit(state.copyWith(foodList: state.foodList));
    }

    try {
      DioApiResponse response = await _menuRepository.updateFoodMetaInfo(event.id, {'inStock': event.status});
      if (response.errorType != NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodsStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodsStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodsToggleCustomCategoryViewEvent(FoodsToggleCustomCategoryViewEvent event, Emitter<FoodsState> emit) async {
    state.list.custom![event.categoryIndex].isOpen = !state.list.custom![event.categoryIndex].isOpen;
    emit(state.copyWith(list: state.list, status: FoodsStatus.success));
  }

  FutureOr<void> _onFoodsToggleMainCategoryViewEvent(FoodsToggleMainCategoryViewEvent event, Emitter<FoodsState> emit) async {
    state.list.main![event.categoryIndex].isOpen = !state.list.main![event.categoryIndex].isOpen;
    emit(state.copyWith(list: state.list, status: FoodsStatus.success));
  }
}
