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
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/models/food_list_response_model.dart';
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/repositories/food_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_list_event.dart';
part 'food_list_state.dart';

class FoodListBloc extends Bloc<FoodListEvent, FoodListState> {
  final FoodRepository _foodRepository = FoodRepository();
  final AuthRepository _authRepository = AuthRepository();
  FoodListBloc() : super(FoodListState(model: FoodCategoryModel(locale: ''))) {
    on<FoodListInitialEvent>(_onFoodListInitialEvent);
    on<FoodListCustomCategoryToggleEvent>(_onFoodListCustomCategoryToggleEvent);
    on<FoodListMainCategoryToggleEvent>(_onFoodListMainCategoryToggleEvent);
  }

  FutureOr<void> _onFoodListInitialEvent(FoodListInitialEvent event, Emitter<FoodListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "food_list"}, 'food_list_screen', 'food_list_screen');
      final String vendorId = await _foodRepository.vendorId();
      emit(state.copyWith(status: FoodListStatus.loading));
      DioApiResponse response = await _foodRepository.getFoodList(vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FoodCategoryModel data = FoodCategoryModel.fromJson(myMap, locale.toString());
        bool isEmpty = data.custom!.isEmpty && data.main!.isEmpty;
        emit(state.copyWith(model: data, status: isEmpty ? FoodListStatus.empty : FoodListStatus.success));
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

  FutureOr<void> _onFoodListCustomCategoryToggleEvent(FoodListCustomCategoryToggleEvent event, Emitter<FoodListState> emit) async {
    state.model.custom![event.index].isOpen = !state.model.custom![event.index].isOpen;
    emit(state.copyWith(model: state.model, status: FoodListStatus.success));
  }

  FutureOr<void> _onFoodListMainCategoryToggleEvent(FoodListMainCategoryToggleEvent event, Emitter<FoodListState> emit) async {
    state.model.main![event.index].isOpen = !state.model.main![event.index].isOpen;
    emit(state.copyWith(model: state.model, status: FoodListStatus.success));
  }
}
