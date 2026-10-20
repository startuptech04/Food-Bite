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
import 'package:vendor/app/core/models/deliveryman_list_response_model.dart';
import 'package:vendor/app/core/models/request/deliveryman_change_blocked_status_request_model.dart';
import 'package:vendor/app/core/models/request/deliveryman_change_hide_status_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/deliveryman_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'deliveryman_list_event.dart';
part 'deliveryman_list_state.dart';

class DeliverymanListBloc extends Bloc<DeliverymanListEvent, DeliverymanListState> {
  final DeliverymanRepository _deliverymanRepository = DeliverymanRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DeliverymanListBloc()
    : super(
        DeliverymanListState(
          pageSize: ApiRequestService.pageSize,
          model: DeliverymanListResponseModel(results: [], locale: ''),
        ),
      ) {
    on<DeliverymanListInitialEvent>(_onDeliverymanListInitialEvent);
    on<DeliverymanListLoadMoreEvent>(_onDeliverymanListLoadMoreEvent);
    on<DeliverymanBlocAccountEvent>(_onDeliverymanBlocAccountEvent);
    on<DeliverymanStatusChangeEvent>(_onDeliverymanStatusChangeEvent);
  }

  FutureOr<void> _onDeliverymanListInitialEvent(DeliverymanListInitialEvent event, Emitter<DeliverymanListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "deliveryman_list"}, 'deliveryman_list_screen', 'deliveryman_list_screen');
      emit(state.copyWith(status: DeliverymanListStatus.loading));
      final String vendorId = await _deliverymanRepository.getVendorId();
      DioApiResponse response = await _deliverymanRepository.getDeliverymanList(vendorId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _accountRepository.getLocale();
        DeliverymanListResponseModel deliveryman = DeliverymanListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: deliveryman, status: deliveryman.results!.isEmpty ? DeliverymanListStatus.empty : DeliverymanListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DeliverymanListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DeliverymanListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDeliverymanListLoadMoreEvent(DeliverymanListLoadMoreEvent event, Emitter<DeliverymanListState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _deliverymanRepository.getVendorId();
        DioApiResponse response = await _deliverymanRepository.getDeliverymanList(vendorId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          DeliverymanListResponseModel deliveryman = DeliverymanListResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: deliveryman, status: deliveryman.results!.isEmpty ? DeliverymanListStatus.empty : DeliverymanListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DeliverymanListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DeliverymanListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onDeliverymanBlocAccountEvent(DeliverymanBlocAccountEvent event, Emitter<DeliverymanListState> emit) async {
    try {
      emit(state.copyWith(status: DeliverymanListStatus.loadingBlockedStart));
      state.model.results![event.index].isBlocked = !state.model.results![event.index].isBlocked!;
      DeliverymanChangeBlockedStatusRequestModel param = DeliverymanChangeBlockedStatusRequestModel(isBlocked: state.model.results![event.index].isBlocked);
      DioApiResponse response = await _deliverymanRepository.updateBlockedStatus(state.model.results![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: DeliverymanListStatus.loadingBlockedSuccess));
        } else {
          emit(state.copyWith(status: DeliverymanListStatus.loadingBlockedFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DeliverymanListStatus.loadingBlockedFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DeliverymanListStatus.loadingBlockedFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDeliverymanStatusChangeEvent(DeliverymanStatusChangeEvent event, Emitter<DeliverymanListState> emit) async {
    try {
      emit(state.copyWith(status: DeliverymanListStatus.loadingHideStart));
      state.model.results![event.index].status = !state.model.results![event.index].status!;
      DeliverymanChangeHideStatusRequestModel param = DeliverymanChangeHideStatusRequestModel(status: state.model.results![event.index].status);
      DioApiResponse response = await _deliverymanRepository.updateHideStatus(state.model.results![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: DeliverymanListStatus.loadingHideSuccess));
        } else {
          emit(state.copyWith(status: DeliverymanListStatus.loadingHideFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DeliverymanListStatus.loadingHideFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DeliverymanListStatus.loadingHideFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
