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
import 'package:vendor/app/core/models/request/join_restaurant_campaign_request_model.dart';
import 'package:vendor/app/core/models/restaurant_campaign_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/campaign_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'restaurant_campaign_event.dart';
part 'restaurant_campaign_state.dart';

class RestaurantCampaignBloc extends Bloc<RestaurantCampaignEvent, RestaurantCampaignState> {
  final CampaignRepository _campaignRepository = CampaignRepository();
  final AccountRepository _accountRepository = AccountRepository();
  RestaurantCampaignBloc()
    : super(
        RestaurantCampaignState(
          campaigns: RestaurantCampaignListModel(locale: ''),
          pageSize: ApiRequestService.pageSize,
          vendorId: '',
        ),
      ) {
    on<RestaurantCampaignInitialEvent>(_onRestaurantCampaignInitialEvent);
    on<RestaurantCampaignLeaveEvent>(_onRestaurantCampaignLeaveEvent);
    on<RestaurantCampaignJoinEvent>(_onRestaurantCampaignJoinEvent);
    on<RestaurantCampaignLoadMoreEvent>(_onRestaurantCampaignLoadMoreEvent);
  }

  FutureOr<void> _onRestaurantCampaignInitialEvent(RestaurantCampaignInitialEvent event, Emitter<RestaurantCampaignState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "restaurant_campaign"}, 'restaurant_campaign_screen', 'restaurant_campaign_screen');
      emit(state.copyWith(status: RestaurantCampaignStatus.loading));
      final String vendorId = await _campaignRepository.getVendorId();
      DioApiResponse response = await _campaignRepository.getRestaurantCampaignNearMe(state.pageSize, state.currentPage, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        RestaurantCampaignListModel data = RestaurantCampaignListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: RestaurantCampaignStatus.success, campaigns: data, vendorId: vendorId));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RestaurantCampaignStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RestaurantCampaignStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRestaurantCampaignLeaveEvent(RestaurantCampaignLeaveEvent event, Emitter<RestaurantCampaignState> emit) async {
    try {
      emit(state.copyWith(status: RestaurantCampaignStatus.loaderStarted));
      DioApiResponse response = await _campaignRepository.leaveRestaurantCampgin(event.campaignId, state.vendorId);
      if (response.errorType == NetErrorType.none) {
        state.campaigns.results!.firstWhere((element) => element.id == event.campaignId).restaurant!.removeWhere((element) => element == state.vendorId);
        emit(state.copyWith(campaigns: state.campaigns, status: RestaurantCampaignStatus.loaderEnded, action: 'leave'));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RestaurantCampaignStatus.loaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RestaurantCampaignStatus.loaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRestaurantCampaignJoinEvent(RestaurantCampaignJoinEvent event, Emitter<RestaurantCampaignState> emit) async {
    try {
      emit(state.copyWith(status: RestaurantCampaignStatus.loaderStarted));
      JoinRestaurantCampaignRequestModel requestParam = JoinRestaurantCampaignRequestModel(campaign: event.campaignId, restaurant: state.vendorId);
      DioApiResponse response = await _campaignRepository.joinRestaurantCampgin(requestParam);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: RestaurantCampaignStatus.loaderEnded, action: 'join'));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RestaurantCampaignStatus.loaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RestaurantCampaignStatus.loaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRestaurantCampaignLoadMoreEvent(RestaurantCampaignLoadMoreEvent event, Emitter<RestaurantCampaignState> emit) async {
    if (state.campaigns.results!.length < state.campaigns.totalResults!) {
      try {
        emit(state.copyWith(status: RestaurantCampaignStatus.loadMore));
        final String vendorId = await _campaignRepository.getVendorId();
        DioApiResponse response = await _campaignRepository.getRestaurantCampaignNearMe(state.pageSize * 2, state.currentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          RestaurantCampaignListModel data = RestaurantCampaignListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: RestaurantCampaignStatus.success, campaigns: data, vendorId: vendorId, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: RestaurantCampaignStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: RestaurantCampaignStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
