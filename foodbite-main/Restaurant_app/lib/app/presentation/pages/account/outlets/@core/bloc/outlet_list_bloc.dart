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
import 'package:vendor/app/core/models/outlet_list_response_model.dart';
import 'package:vendor/app/core/models/request/update_outlet_status_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/outlet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'outlet_list_event.dart';
part 'outlet_list_state.dart';

class OutletListBloc extends Bloc<OutletListEvent, OutletListState> {
  final OutletRepository _outletRepository = OutletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  OutletListBloc()
    : super(
        OutletListState(
          model: OutletListResponseModel(results: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<OutletListInitialEvent>(_onOutletListInitialEvent);
    on<OutletListLoadMoreEvent>(_onOutletListLoadMoreEvent);
    on<OutletListStatusChangeEvent>(_onOutletListStatusChangeEvent);
  }

  FutureOr<void> _onOutletListInitialEvent(OutletListInitialEvent event, Emitter<OutletListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "outlet_list"}, 'outlet_list_screen', 'outlet_list_screen');
      emit(state.copyWith(status: OutletListStatus.loading));
      final String vendorId = await _outletRepository.getVendorId();
      DioApiResponse response = await _outletRepository.getOutletList(vendorId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OutletListResponseModel waiter = OutletListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: waiter, status: waiter.results!.isEmpty ? OutletListStatus.empty : OutletListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OutletListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OutletListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOutletListLoadMoreEvent(OutletListLoadMoreEvent event, Emitter<OutletListState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _outletRepository.getVendorId();
        DioApiResponse response = await _outletRepository.getOutletList(vendorId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OutletListResponseModel waiter = OutletListResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: waiter, status: waiter.results!.isEmpty ? OutletListStatus.empty : OutletListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OutletListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OutletListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onOutletListStatusChangeEvent(OutletListStatusChangeEvent event, Emitter<OutletListState> emit) async {
    try {
      emit(state.copyWith(status: OutletListStatus.loadingHideStart));
      state.model.results![event.index].status = !state.model.results![event.index].status!;
      OutletUpdateStatusRequestModel param = OutletUpdateStatusRequestModel(status: state.model.results![event.index].status);
      DioApiResponse response = await _outletRepository.updateOutletStatus(state.model.results![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: OutletListStatus.loadingHideSuccess));
        } else {
          emit(state.copyWith(status: OutletListStatus.loadingHideFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OutletListStatus.loadingHideFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OutletListStatus.loadingHideFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
