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
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/models/food_list_model.dart';
import 'package:kitchen/app/core/models/server_error_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_list_event.dart';
part 'food_list_state.dart';

class FoodListBloc extends Bloc<FoodListEvent, FoodListState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AuthRepository _authRepository = AuthRepository();
  FoodListBloc() : super(FoodListState(list: FoodListModel(locale: ''))) {
    on<FoodListInitialEvent>(_onFoodListInitialEvent);
    on<FoodListToggleCustomCategoryViewEvent>(_onFoodListToggleCustomCategoryViewEvent);
    on<FoodListToggleMainCategoryViewEvent>(_onFoodListToggleMainCategoryViewEvent);
    on<FoodListUpdateStockEvent>(_onFoodListUpdateStockEvent);
  }

  FutureOr<void> _onFoodListInitialEvent(FoodListInitialEvent event, Emitter<FoodListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "food_list"}, 'food_list_screen', 'food_list_screen');
      emit(state.copyWith(status: FoodListStatus.loading));
      DioApiResponse response = await _menuRepository.getFoodList();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FoodListModel data = FoodListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(list: data, status: data.custom!.isEmpty && data.main!.isEmpty ? FoodListStatus.empty : FoodListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodListToggleCustomCategoryViewEvent(FoodListToggleCustomCategoryViewEvent event, Emitter<FoodListState> emit) async {
    state.list.custom![event.categoryIndex].isOpen = !state.list.custom![event.categoryIndex].isOpen;
    emit(state.copyWith(list: state.list, status: FoodListStatus.success));
  }

  FutureOr<void> _onFoodListToggleMainCategoryViewEvent(FoodListToggleMainCategoryViewEvent event, Emitter<FoodListState> emit) async {
    state.list.main![event.categoryIndex].isOpen = !state.list.main![event.categoryIndex].isOpen;
    emit(state.copyWith(list: state.list, status: FoodListStatus.success));
  }

  FutureOr<void> _onFoodListUpdateStockEvent(FoodListUpdateStockEvent event, Emitter<FoodListState> emit) async {
    if (event.listFrom == 'main') {
      state.list.main![event.categoryIndex].foods!.firstWhere((element) => element.id == event.id).inStock = event.status;
      emit(state.copyWith(list: state.list));
    } else if (event.listFrom == 'custom') {
      state.list.custom![event.categoryIndex].foods!.firstWhere((element) => element.id == event.id).inStock = event.status;
      emit(state.copyWith(list: state.list));
    }
    try {
      DioApiResponse response = await _menuRepository.updateFoodMetaInfo(event.id, {'inStock': event.status});
      if (response.errorType != NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodListStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
