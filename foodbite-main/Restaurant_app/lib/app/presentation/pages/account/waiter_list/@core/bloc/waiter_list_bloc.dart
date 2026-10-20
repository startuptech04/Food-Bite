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
import 'package:vendor/app/core/models/request/update_waiter_status_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/waiter_list_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/waiter_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'waiter_list_event.dart';
part 'waiter_list_state.dart';

class WaiterListBloc extends Bloc<WaiterListEvent, WaiterListState> {
  final WaiterRepository _waiterRepository = WaiterRepository();
  final AccountRepository _accountRepository = AccountRepository();
  WaiterListBloc()
    : super(
        WaiterListState(
          pageSize: ApiRequestService.pageSize,
          model: WaiterListResponseModel(results: [], success: false),
        ),
      ) {
    on<WaiterListInitialEvent>(_onWaiterListInitialEvent);
    on<WaiterListLoadMoreEvent>(_onWaiterListLoadMoreEvent);
    on<WaiterListStatusChangeEvent>(_onWaiterListStatusChangeEvent);
  }

  FutureOr<void> _onWaiterListInitialEvent(WaiterListInitialEvent event, Emitter<WaiterListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "waiter_list"}, 'waiter_list_screen', 'waiter_list_screen');
      emit(state.copyWith(status: WaiterListStatus.loading));
      final String vendorId = await _waiterRepository.getVendorId();
      DioApiResponse response = await _waiterRepository.getWaiterList(vendorId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        WaiterListResponseModel waiter = WaiterListResponseModel.fromJson(myMap);
        emit(state.copyWith(model: waiter, status: waiter.results!.isEmpty ? WaiterListStatus.empty : WaiterListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: WaiterListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: WaiterListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onWaiterListLoadMoreEvent(WaiterListLoadMoreEvent event, Emitter<WaiterListState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _waiterRepository.getVendorId();
        DioApiResponse response = await _waiterRepository.getWaiterList(vendorId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          WaiterListResponseModel waiter = WaiterListResponseModel.fromJson(myMap);
          emit(state.copyWith(model: waiter, status: waiter.results!.isEmpty ? WaiterListStatus.empty : WaiterListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: WaiterListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: WaiterListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onWaiterListStatusChangeEvent(WaiterListStatusChangeEvent event, Emitter<WaiterListState> emit) async {
    try {
      emit(state.copyWith(status: WaiterListStatus.loadingHideStart));
      state.model.results![event.index].status = !state.model.results![event.index].status!;
      UpdateWaiterStatusRequestModel param = UpdateWaiterStatusRequestModel(status: state.model.results![event.index].status);
      DioApiResponse response = await _waiterRepository.updateWaiterStatus(state.model.results![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: WaiterListStatus.loadingHideSuccess));
        } else {
          emit(state.copyWith(status: WaiterListStatus.loadingHideFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: WaiterListStatus.loadingHideFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: WaiterListStatus.loadingHideFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
