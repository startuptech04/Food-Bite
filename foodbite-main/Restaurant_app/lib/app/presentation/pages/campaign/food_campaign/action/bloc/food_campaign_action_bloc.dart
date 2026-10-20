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
import 'package:vendor/app/core/models/food_campaign_details_food_list_model.dart';
import 'package:vendor/app/core/models/request/join_food_campaign_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/campaign_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_campaign_action_event.dart';
part 'food_campaign_action_state.dart';

class FoodCampaignActionBloc extends Bloc<FoodCampaignActionEvent, FoodCampaignActionState> {
  final CampaignRepository _campaignRepository = CampaignRepository();
  final AccountRepository _accountRepository = AccountRepository();
  FoodCampaignActionBloc()
    : super(
        FoodCampaignActionState(
          id: '',
          title: '',
          savedFoods: [],
          vendorId: '',
          campaigns: FoodCampaignDetailsMyFoodListModel(locale: ''),
        ),
      ) {
    on<FoodCampaignActionInitialEvent>(_onFoodCampaignActionInitialEvent);
    on<FoodCampaignActionJoinEvent>(_onFoodCampaignActionJoinEvent);
    on<FoodCampaignActionLeaveEvent>(_onFoodCampaignActionLeaveEvent);
  }

  FutureOr<void> _onFoodCampaignActionInitialEvent(FoodCampaignActionInitialEvent event, Emitter<FoodCampaignActionState> emit) async {
    try {
      emit(state.copyWith(id: event.id, title: event.title, savedFoods: event.savedFoods));
      await _accountRepository.saveEvent('visited_screen', {"screen": "join_food_campaign"}, 'join_food_campaign_screen', 'join_food_campaign_screen');
      final String vendorId = await _campaignRepository.getVendorId();
      emit(state.copyWith(status: FoodCampaignActionStatus.loading));
      DioApiResponse response = await _campaignRepository.getFoodCampaignDetails(event.id, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FoodCampaignDetailsMyFoodListModel data = FoodCampaignDetailsMyFoodListModel.fromJson(myMap, locale.toString());
        data.info!.foods!.removeWhere((element) => element.restaurant != vendorId);
        emit(state.copyWith(campaigns: data, status: FoodCampaignActionStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodCampaignActionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodCampaignActionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodCampaignActionJoinEvent(FoodCampaignActionJoinEvent event, Emitter<FoodCampaignActionState> emit) async {
    try {
      emit(state.copyWith(status: FoodCampaignActionStatus.loaderStarted));
      final String vendorId = await _campaignRepository.getVendorId();
      JoinFoodCampaignRequestModel foodParam = JoinFoodCampaignRequestModel(restaurant: vendorId, food: event.id, campaign: state.id);
      DioApiResponse response = await _campaignRepository.joinFoodCampgin(foodParam);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: FoodCampaignActionStatus.loaderEnded, action: 'join'));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodCampaignActionStatus.loaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodCampaignActionStatus.loaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodCampaignActionLeaveEvent(FoodCampaignActionLeaveEvent event, Emitter<FoodCampaignActionState> emit) async {
    try {
      emit(state.copyWith(status: FoodCampaignActionStatus.loaderStarted));
      DioApiResponse response = await _campaignRepository.leaveFoodCampgin(state.id, event.id);
      if (response.errorType == NetErrorType.none) {
        state.savedFoods.removeWhere((element) => element == event.id);
        state.campaigns.info!.foods!.removeAt(event.index);
        state.campaigns.info!.foods = [...state.campaigns.info!.foods!];
        emit(state.copyWith(status: FoodCampaignActionStatus.loaderEnded, action: 'leave', savedFoods: state.savedFoods, campaigns: state.campaigns));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodCampaignActionStatus.loaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodCampaignActionStatus.loaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
