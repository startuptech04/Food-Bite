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
import 'package:vendor/app/core/models/food_campaign_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/campaign_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_campaign_event.dart';
part 'food_campaign_state.dart';

class FoodCampaignBloc extends Bloc<FoodCampaignEvent, FoodCampaignState> {
  final CampaignRepository _campaignRepository = CampaignRepository();
  final AccountRepository _accountRepository = AccountRepository();
  FoodCampaignBloc()
    : super(
        FoodCampaignState(
          campaigns: FoodCampaignListModel(locale: ''),
          pageSize: ApiRequestService.pageSize,
          vendorId: '',
        ),
      ) {
    on<FoodCampaignInitialEvent>(_onFoodCampaignInitialEvent);
    on<FoodCampaignLoadMoreEvent>(_onFoodCampaignLoadMoreEvent);
  }

  FutureOr<void> _onFoodCampaignInitialEvent(FoodCampaignInitialEvent event, Emitter<FoodCampaignState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "food_campaign"}, 'food_campaign_screen', 'food_campaign_screen');
      emit(state.copyWith(status: FoodCampaignStatus.loading));
      final String vendorId = await _campaignRepository.getVendorId();
      DioApiResponse response = await _campaignRepository.getFoodCampaignNearMe(state.pageSize, state.currentPage, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FoodCampaignListModel data = FoodCampaignListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: FoodCampaignStatus.success, campaigns: data, vendorId: vendorId));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodCampaignStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodCampaignStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodCampaignLoadMoreEvent(FoodCampaignLoadMoreEvent event, Emitter<FoodCampaignState> emit) async {
    if (state.campaigns.results!.length < state.campaigns.totalResults!) {
      try {
        emit(state.copyWith(status: FoodCampaignStatus.loadMore));
        final String vendorId = await _campaignRepository.getVendorId();
        DioApiResponse response = await _campaignRepository.getFoodCampaignNearMe(state.pageSize * 2, state.currentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          FoodCampaignListModel data = FoodCampaignListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: FoodCampaignStatus.success, campaigns: data, vendorId: vendorId, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: FoodCampaignStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FoodCampaignStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
