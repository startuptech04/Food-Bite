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
import 'package:vendor/app/core/models/dining_coupon_list_response_model.dart';
import 'package:vendor/app/core/models/request/update_dining_coupon_meta_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/coupon_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_coupon_list_event.dart';
part 'dining_coupon_list_state.dart';

class DiningCouponListBloc extends Bloc<DiningCouponListEvent, DiningCouponListState> {
  final CouponRepository _couponRepository = CouponRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningCouponListBloc()
    : super(
        DiningCouponListState(
          pageSize: ApiRequestService.pageSize,
          model: DiningCouponListResponseModel(coupons: [], locale: ''),
        ),
      ) {
    on<DiningCouponListInitialEvent>(_onDiningCouponListInitialEvent);
    on<DiningCouponListLoadMoreEvent>(_onDiningCouponListLoadMoreEvent);
    on<DiningCouponListChangeStatusEvent>(_onDiningCouponListChangeStatusEvent);
    on<DiningCouponListDeleteEvent>(_onDiningCouponListDeleteEvent);
  }

  FutureOr<void> _onDiningCouponListInitialEvent(DiningCouponListInitialEvent event, Emitter<DiningCouponListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_coupon_list"}, 'dining_coupon_list_screen', 'dining_coupon_list_screen');
      emit(state.copyWith(status: DiningCouponListStatus.loading));
      final String vendorId = await _couponRepository.getVendorId();
      final String userId = await _couponRepository.getUserId();
      DioApiResponse response = await _couponRepository.getDiningCouponList(vendorId, userId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningCouponListResponseModel data = DiningCouponListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.coupons!.isEmpty ? DiningCouponListStatus.empty : DiningCouponListStatus.success, appLocale: locale.toString()));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningCouponListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningCouponListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningCouponListLoadMoreEvent(DiningCouponListLoadMoreEvent event, Emitter<DiningCouponListState> emit) async {
    if (state.model.coupons!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _couponRepository.getVendorId();
        final String userId = await _couponRepository.getUserId();
        DioApiResponse response = await _couponRepository.getDiningCouponList(vendorId, userId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          DiningCouponListResponseModel data = DiningCouponListResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, status: data.coupons!.isEmpty ? DiningCouponListStatus.empty : DiningCouponListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DiningCouponListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DiningCouponListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onDiningCouponListChangeStatusEvent(DiningCouponListChangeStatusEvent event, Emitter<DiningCouponListState> emit) async {
    try {
      if (state.model.coupons![event.index].status! == 'live') {
        state.model.coupons![event.index].status = 'hide';
      } else {
        state.model.coupons![event.index].status = 'live';
      }
      emit(state.copyWith(status: DiningCouponListStatus.loadingHideStart));
      UpdateDiningCouponMetaRequestModel param = UpdateDiningCouponMetaRequestModel(status: state.model.coupons![event.index].status!);
      DioApiResponse response = await _couponRepository.updateDiningCouponMetaInfo(state.model.coupons![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: DiningCouponListStatus.loadingHideSuccess));
        } else {
          emit(state.copyWith(status: DiningCouponListStatus.loadingHideFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningCouponListStatus.loadingHideFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningCouponListStatus.loadingHideFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningCouponListDeleteEvent(DiningCouponListDeleteEvent event, Emitter<DiningCouponListState> emit) async {
    try {
      emit(state.copyWith(status: DiningCouponListStatus.loadingDeleteStart));
      final String userId = await _couponRepository.getUserId();
      DioApiResponse response = await _couponRepository.deleteDiningCoupon(state.model.coupons![event.index].id!, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: DiningCouponListStatus.loadingDeleteSuccess));
          state.model.coupons!.removeAt(event.index);
          emit(state.copyWith(model: state.model, status: state.model.coupons!.isEmpty ? DiningCouponListStatus.empty : DiningCouponListStatus.success));
        } else {
          emit(state.copyWith(status: DiningCouponListStatus.loadingDeleteFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningCouponListStatus.loadingDeleteFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningCouponListStatus.loadingDeleteFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
