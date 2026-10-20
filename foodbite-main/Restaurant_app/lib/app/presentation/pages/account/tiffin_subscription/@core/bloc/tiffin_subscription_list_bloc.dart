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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/request/tiffin_subscription_update_status_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_package_list_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/tiffin_subscription_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'tiffin_subscription_list_event.dart';
part 'tiffin_subscription_list_state.dart';

class TiffinSubscriptionListBloc extends Bloc<TiffinSubscriptionListEvent, TiffinSubscriptionListState> {
  final TiffinSubscriptionRepository _tiffinSubscriptionRepository = TiffinSubscriptionRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TiffinSubscriptionListBloc()
    : super(
        TiffinSubscriptionListState(
          pageSize: ApiRequestService.pageSize,
          model: TiffinSubscriptionPackageListResponseModel(results: [], locale: ''),
        ),
      ) {
    on<TiffinSubscriptionListInitialEvent>(_onTiffinSubscriptionListInitialEvent);
    on<TiffinSubscriptionListLoadMoreEvent>(_onTiffinSubscriptionListLoadMoreEvent);
    on<TiffinSubscriptionListUpdateStatusEvent>(_onTiffinSubscriptionListUpdateStatusEvent);
    on<TiffinSubscriptionListDeleteEvent>(_onTiffinSubscriptionListDeleteEvent);
  }

  FutureOr<void> _onTiffinSubscriptionListInitialEvent(TiffinSubscriptionListInitialEvent event, Emitter<TiffinSubscriptionListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "tiffin_subscription_packages"}, 'tiffin_subscription_packages_screen', 'tiffin_subscription_packages_screen');
      emit(state.copyWith(status: TiffinSubscriptionListStatus.loading));
      final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
      DioApiResponse response = await _tiffinSubscriptionRepository.getMyTiffinSubscription(vendorId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TiffinSubscriptionPackageListResponseModel data = TiffinSubscriptionPackageListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, appLocale: locale.toString(), status: data.results!.isEmpty ? TiffinSubscriptionListStatus.empty : TiffinSubscriptionListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTiffinSubscriptionListLoadMoreEvent(TiffinSubscriptionListLoadMoreEvent event, Emitter<TiffinSubscriptionListState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _tiffinSubscriptionRepository.getVendorId();
        DioApiResponse response = await _tiffinSubscriptionRepository.getMyTiffinSubscription(vendorId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          TiffinSubscriptionPackageListResponseModel data = TiffinSubscriptionPackageListResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, status: data.results!.isEmpty ? TiffinSubscriptionListStatus.empty : TiffinSubscriptionListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: TiffinSubscriptionListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: TiffinSubscriptionListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onTiffinSubscriptionListUpdateStatusEvent(TiffinSubscriptionListUpdateStatusEvent event, Emitter<TiffinSubscriptionListState> emit) async {
    try {
      if (state.model.results![event.index].status! == 'live') {
        state.model.results![event.index].status = 'hide';
      } else {
        state.model.results![event.index].status = 'live';
      }
      emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingHideStart));
      UpdateTiffinSubscriptionStatusModel param = UpdateTiffinSubscriptionStatusModel(status: state.model.results![event.index].status!);
      DioApiResponse response = await _tiffinSubscriptionRepository.updateTiffinSubscriptionStatus(state.model.results![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: TiffinSubscriptionListStatus.loadingHideSuccess));
        } else {
          emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingHideFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingHideFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingHideFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTiffinSubscriptionListDeleteEvent(TiffinSubscriptionListDeleteEvent event, Emitter<TiffinSubscriptionListState> emit) async {
    try {
      emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingDeleteStart));
      DioApiResponse response = await _tiffinSubscriptionRepository.deleteTiffinSubscription(state.model.results![event.index].id!);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: TiffinSubscriptionListStatus.loadingDeleteSuccess));
          state.model.results!.removeAt(event.index);
          emit(state.copyWith(model: state.model, status: state.model.results!.isEmpty ? TiffinSubscriptionListStatus.empty : TiffinSubscriptionListStatus.success));
        } else {
          emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingDeleteFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingDeleteFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TiffinSubscriptionListStatus.loadingDeleteFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
