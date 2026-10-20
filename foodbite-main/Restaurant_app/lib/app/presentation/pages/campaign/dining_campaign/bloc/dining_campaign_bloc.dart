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
import 'package:vendor/app/core/models/dining_campaign_list_model.dart';
import 'package:vendor/app/core/models/request/join_dining_campaign_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/campaign_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_campaign_event.dart';
part 'dining_campaign_state.dart';

class DiningCampaignBloc extends Bloc<DiningCampaignEvent, DiningCampaignState> {
  final CampaignRepository _campaignRepository = CampaignRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningCampaignBloc()
    : super(
        DiningCampaignState(
          campaigns: DiningCampaignListModel(locale: ''),
          pageSize: ApiRequestService.pageSize,
          vendorId: '',
        ),
      ) {
    on<DiningCampaignInitialEvent>(_onDiningCampaignInitialEvent);
    on<DiningCampaignLeaveEvent>(_onDiningCampaignLeaveEvent);
    on<DiningCampaignJoinEvent>(_onDiningCampaignJoinEvent);
    on<DiningCampaignLoadMoreEvent>(_onDiningCampaignLoadMoreEvent);
  }

  FutureOr<void> _onDiningCampaignInitialEvent(DiningCampaignInitialEvent event, Emitter<DiningCampaignState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_campaign"}, 'dining_campaign_screen', 'dining_campaign_screen');
      emit(state.copyWith(status: DiningCampaignStatus.loading));
      final String vendorId = await _campaignRepository.getVendorId();
      DioApiResponse response = await _campaignRepository.getDiningCampaignNearMe(state.pageSize, state.currentPage, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningCampaignListModel data = DiningCampaignListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: DiningCampaignStatus.success, campaigns: data, vendorId: vendorId));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningCampaignStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningCampaignStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningCampaignLeaveEvent(DiningCampaignLeaveEvent event, Emitter<DiningCampaignState> emit) async {
    final bool preBookingPermission = await _campaignRepository.getPreBookingPermission();
    if (preBookingPermission) {
      try {
        emit(state.copyWith(status: DiningCampaignStatus.loaderStarted));
        DioApiResponse response = await _campaignRepository.leaveDiningCampaign(event.campaignId, state.vendorId);
        if (response.errorType == NetErrorType.none) {
          state.campaigns.results!.firstWhere((element) => element.id == event.campaignId).restaurant!.removeWhere((element) => element == state.vendorId);
          emit(state.copyWith(campaigns: state.campaigns, status: DiningCampaignStatus.loaderEnded, action: 'leave'));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DiningCampaignStatus.loaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DiningCampaignStatus.loaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      emit(state.copyWith(status: DiningCampaignStatus.customError, statusCode: 0, alertMessage: "Sorry, you don't have pre booking permission", extraMessage: ''));
    }
  }

  FutureOr<void> _onDiningCampaignJoinEvent(DiningCampaignJoinEvent event, Emitter<DiningCampaignState> emit) async {
    final bool preBookingPermission = await _campaignRepository.getPreBookingPermission();
    if (preBookingPermission) {
      try {
        emit(state.copyWith(status: DiningCampaignStatus.loaderStarted));
        JoinDiningCampaignRequestModel requestParam = JoinDiningCampaignRequestModel(campaign: event.campaignId, restaurant: state.vendorId);
        DioApiResponse response = await _campaignRepository.joinDiningCampaign(requestParam);
        if (response.errorType == NetErrorType.none) {
          emit(state.copyWith(status: DiningCampaignStatus.loaderEnded, action: 'join'));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DiningCampaignStatus.loaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DiningCampaignStatus.loaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      emit(state.copyWith(status: DiningCampaignStatus.customError, statusCode: 0, alertMessage: "Sorry, you don't have pre booking permission", extraMessage: ''));
    }
  }

  FutureOr<void> _onDiningCampaignLoadMoreEvent(DiningCampaignLoadMoreEvent event, Emitter<DiningCampaignState> emit) async {
    if (state.campaigns.results!.length < state.campaigns.totalResults!) {
      try {
        emit(state.copyWith(status: DiningCampaignStatus.loadMore));
        final String vendorId = await _campaignRepository.getVendorId();
        DioApiResponse response = await _campaignRepository.getDiningCampaignNearMe(state.pageSize * 2, state.currentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          DiningCampaignListModel data = DiningCampaignListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: DiningCampaignStatus.success, campaigns: data, vendorId: vendorId, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DiningCampaignStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DiningCampaignStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
