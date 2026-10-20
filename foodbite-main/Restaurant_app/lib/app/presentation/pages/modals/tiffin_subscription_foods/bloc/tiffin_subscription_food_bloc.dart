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
import 'package:vendor/app/core/models/tiffin_subscription_food_list_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/tiffin_subscription_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'tiffin_subscription_food_event.dart';
part 'tiffin_subscription_food_state.dart';

class TiffinSubscriptionFoodBloc extends Bloc<TiffinSubscriptionFoodEvent, TiffinSubscriptionFoodState> {
  final TiffinSubscriptionRepository _tiffinSubscriptionRepository = TiffinSubscriptionRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TiffinSubscriptionFoodBloc()
    : super(
        TiffinSubscriptionFoodState(
          model: TiffinSubscriptionFoodListResponseModel(foods: [], locale: ''),
        ),
      ) {
    on<TiffinSubscriptionFoodInitialEvent>(_onTiffinSubscriptionFoodInitialEvent);
    on<TiffinSubscriptionFoodSelectEvent>(_onTiffinSubscriptionFoodSelectEvent);
    on<TiffinSubscriptionFoodSaveEvent>(_onTiffinSubscriptionFoodSaveEvent);
  }

  FutureOr<void> _onTiffinSubscriptionFoodInitialEvent(TiffinSubscriptionFoodInitialEvent event, Emitter<TiffinSubscriptionFoodState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "tiffin_subscription_food_list"}, 'tiffin_subscription_food_list_screen', 'tiffin_subscription_food_list_screen');
      emit(state.copyWith(status: TiffinSubscriptionFoodStatus.loading));
      final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
      DioApiResponse response = await _tiffinSubscriptionRepository.getTiffinSubscriptionFoodList(vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TiffinSubscriptionFoodListResponseModel data = TiffinSubscriptionFoodListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.foods!.isNotEmpty ? TiffinSubscriptionFoodStatus.success : TiffinSubscriptionFoodStatus.empty, model: data, foodList: event.foodList));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionFoodStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionFoodStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTiffinSubscriptionFoodSelectEvent(TiffinSubscriptionFoodSelectEvent event, Emitter<TiffinSubscriptionFoodState> emit) async {
    List<String> foodIds = <String>[];
    for (var element in state.foodList) {
      foodIds.add(element);
    }
    if (foodIds.contains(event.foodId)) {
      foodIds.removeWhere((element) => element == event.foodId);
    } else {
      foodIds.add(event.foodId);
    }
    emit(state.copyWith(foodList: foodIds));
  }

  FutureOr<void> _onTiffinSubscriptionFoodSaveEvent(TiffinSubscriptionFoodSaveEvent event, Emitter<TiffinSubscriptionFoodState> emit) async {
    emit(state.copyWith(status: TiffinSubscriptionFoodStatus.saveItem));
  }
}
