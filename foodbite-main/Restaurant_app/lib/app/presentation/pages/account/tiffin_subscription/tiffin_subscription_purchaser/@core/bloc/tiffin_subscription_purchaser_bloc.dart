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
import 'package:vendor/app/core/models/request/tiffin_subscription_purchaser_history_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_purchaser_history_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/tiffin_subscription_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'tiffin_subscription_purchaser_event.dart';
part 'tiffin_subscription_purchaser_state.dart';

class TiffinSubscriptionPurchaserBloc extends Bloc<TiffinSubscriptionPurchaserEvent, TiffinSubscriptionPurchaserState> {
  final TiffinSubscriptionRepository _tiffinSubscriptionRepository = TiffinSubscriptionRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TiffinSubscriptionPurchaserBloc()
    : super(
        TiffinSubscriptionPurchaserState(
          pageSize: ApiRequestService.pageSize,
          model: TiffinSubscriptionPurchaserHistoryResponseModel(results: [], locale: ''),
        ),
      ) {
    on<TiffinSubscriptionPurchaserInitialEvent>(_onTiffinSubscriptionPurchaserInitialEvent);
    on<TiffinSubscriptionPurchaserLoadMoreEvent>(_onTiffinSubscriptionPurchaserLoadMoreEvent);
    on<TiffinSubscriptionPurchaserPullRefreshEvent>(_onTiffinSubscriptionPurchaserPullRefreshEvent);
  }

  FutureOr<void> _onTiffinSubscriptionPurchaserInitialEvent(TiffinSubscriptionPurchaserInitialEvent event, Emitter<TiffinSubscriptionPurchaserState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "tiffin_package_purchase_list"}, 'tiffin_package_purchase_list_screen', 'tiffin_package_purchase_list_screen');
      emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.loading, tiffinId: event.tiffinId));
      final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
      TiffinSubscriptionPurchaserHistoryRequestModel param = TiffinSubscriptionPurchaserHistoryRequestModel(limit: state.pageSize, page: state.currentPage, vendor: vendorId, id: event.tiffinId);
      DioApiResponse response = await _tiffinSubscriptionRepository.getPurchaserHistory(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TiffinSubscriptionPurchaserHistoryResponseModel data = TiffinSubscriptionPurchaserHistoryResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.results!.isNotEmpty ? TiffinSubscriptionPurchaserStatus.success : TiffinSubscriptionPurchaserStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTiffinSubscriptionPurchaserLoadMoreEvent(TiffinSubscriptionPurchaserLoadMoreEvent event, Emitter<TiffinSubscriptionPurchaserState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
        TiffinSubscriptionPurchaserHistoryRequestModel param = TiffinSubscriptionPurchaserHistoryRequestModel(limit: state.pageSize * 2, page: state.currentPage, vendor: vendorId, id: state.tiffinId);
        DioApiResponse response = await _tiffinSubscriptionRepository.getPurchaserHistory(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          TiffinSubscriptionPurchaserHistoryResponseModel data = TiffinSubscriptionPurchaserHistoryResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, status: data.results!.isNotEmpty ? TiffinSubscriptionPurchaserStatus.success : TiffinSubscriptionPurchaserStatus.empty, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), loadMore: false, extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onTiffinSubscriptionPurchaserPullRefreshEvent(TiffinSubscriptionPurchaserPullRefreshEvent event, Emitter<TiffinSubscriptionPurchaserState> emit) async {
    try {
      emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.loading));
      final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
      TiffinSubscriptionPurchaserHistoryRequestModel param = TiffinSubscriptionPurchaserHistoryRequestModel(limit: state.pageSize, page: state.currentPage, vendor: vendorId, id: state.tiffinId);
      DioApiResponse response = await _tiffinSubscriptionRepository.getPurchaserHistory(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TiffinSubscriptionPurchaserHistoryResponseModel data = TiffinSubscriptionPurchaserHistoryResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.results!.isNotEmpty ? TiffinSubscriptionPurchaserStatus.success : TiffinSubscriptionPurchaserStatus.empty, pageSize: ApiRequestService.pageSize));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionPurchaserStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
