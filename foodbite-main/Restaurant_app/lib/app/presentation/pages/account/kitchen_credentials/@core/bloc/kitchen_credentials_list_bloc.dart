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
import 'package:vendor/app/core/models/kitchen_owner_list_model.dart';
import 'package:vendor/app/core/models/request/update_kitchen_owner_status_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'kitchen_credentials_list_event.dart';
part 'kitchen_credentials_list_state.dart';

class KitchenCredentialsListBloc extends Bloc<KitchenCredentialsListEvent, KitchenCredentialsListState> {
  final AccountRepository _accountRepository = AccountRepository();
  KitchenCredentialsListBloc()
    : super(
        KitchenCredentialsListState(
          pageSize: ApiRequestService.pageSize,
          model: KitchenOwnerListResponseModel(results: [], success: false),
        ),
      ) {
    on<KitchenCredentialsListInitialEvent>(_onKitchenCredentialsListInitialEvent);
    on<KitchenCredentialsListLoadMoreEvent>(_onKitchenCredentialsListLoadMoreEvent);
    on<KitchenCredentialsListStatusChangeEvent>(_onKitchenCredentialsListStatusChangeEvent);
  }

  FutureOr<void> _onKitchenCredentialsListInitialEvent(KitchenCredentialsListInitialEvent event, Emitter<KitchenCredentialsListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "kitchen_owner"}, 'kitchen_owner_screen', 'kitchen_owner_screen');
      emit(state.copyWith(status: KitchenCredentialsListStatus.loading));
      final String vendorId = await _accountRepository.getVendorId();
      DioApiResponse response = await _accountRepository.getKitchenOwnerList(vendorId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        KitchenOwnerListResponseModel waiter = KitchenOwnerListResponseModel.fromJson(myMap);
        emit(state.copyWith(model: waiter, status: waiter.results!.isEmpty ? KitchenCredentialsListStatus.empty : KitchenCredentialsListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: KitchenCredentialsListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: KitchenCredentialsListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onKitchenCredentialsListLoadMoreEvent(KitchenCredentialsListLoadMoreEvent event, Emitter<KitchenCredentialsListState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _accountRepository.getVendorId();
        DioApiResponse response = await _accountRepository.getKitchenOwnerList(vendorId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          KitchenOwnerListResponseModel waiter = KitchenOwnerListResponseModel.fromJson(myMap);
          emit(state.copyWith(model: waiter, status: waiter.results!.isEmpty ? KitchenCredentialsListStatus.empty : KitchenCredentialsListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: KitchenCredentialsListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: KitchenCredentialsListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onKitchenCredentialsListStatusChangeEvent(KitchenCredentialsListStatusChangeEvent event, Emitter<KitchenCredentialsListState> emit) async {
    try {
      emit(state.copyWith(status: KitchenCredentialsListStatus.loadingHideStart));
      state.model.results![event.index].status = !state.model.results![event.index].status!;
      UpdateKitchenOwnerStatusRequestModel param = UpdateKitchenOwnerStatusRequestModel(status: state.model.results![event.index].status);
      DioApiResponse response = await _accountRepository.updateKitchenOwnerStatus(state.model.results![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: KitchenCredentialsListStatus.loadingHideSuccess));
        } else {
          emit(state.copyWith(status: KitchenCredentialsListStatus.loadingHideFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: KitchenCredentialsListStatus.loadingHideFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: KitchenCredentialsListStatus.loadingHideFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
