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
import 'package:vendor/app/core/models/order_coupon_list_model.dart';
import 'package:vendor/app/core/models/request/update_order_coupon_meta_info_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/coupon_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_coupon_list_event.dart';
part 'order_coupon_list_state.dart';

class OrderCouponListBloc extends Bloc<OrderCouponListEvent, OrderCouponListState> {
  final CouponRepository _couponRepository = CouponRepository();
  final AccountRepository _accountRepository = AccountRepository();
  OrderCouponListBloc()
    : super(
        OrderCouponListState(
          pageSize: ApiRequestService.pageSize,
          model: OrderCouponListModel(coupons: [], locale: ''),
        ),
      ) {
    on<OrderCouponListInitialEvent>(_onOrderCouponListInitialEvent);
    on<OrderCouponListLoadMoreEvent>(_onOrderCouponListLoadMoreEvent);
    on<OrderCouponListChangeStatusEvent>(_onOrderCouponListChangeStatusEvent);
    on<OrderCouponListDeleteEvent>(_onOrderCouponListDeleteEvent);
  }

  FutureOr<void> _onOrderCouponListInitialEvent(OrderCouponListInitialEvent event, Emitter<OrderCouponListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "order_coupon_list"}, 'order_coupon_list_screen', 'order_coupon_list_screen');
      emit(state.copyWith(status: OrderCouponListStatus.loading));
      final String vendorId = await _couponRepository.getVendorId();
      final String userId = await _couponRepository.getUserId();
      DioApiResponse response = await _couponRepository.getOrderCouponList(vendorId, userId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderCouponListModel deliveryman = OrderCouponListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: deliveryman, appLocale: locale.toString(), status: deliveryman.coupons!.isEmpty ? OrderCouponListStatus.empty : OrderCouponListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderCouponListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderCouponListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderCouponListLoadMoreEvent(OrderCouponListLoadMoreEvent event, Emitter<OrderCouponListState> emit) async {
    if (state.model.coupons!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _couponRepository.getVendorId();
        final String userId = await _couponRepository.getUserId();
        DioApiResponse response = await _couponRepository.getOrderCouponList(vendorId, userId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OrderCouponListModel deliveryman = OrderCouponListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: deliveryman, status: deliveryman.coupons!.isEmpty ? OrderCouponListStatus.empty : OrderCouponListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderCouponListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderCouponListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onOrderCouponListChangeStatusEvent(OrderCouponListChangeStatusEvent event, Emitter<OrderCouponListState> emit) async {
    try {
      if (state.model.coupons![event.index].status! == 'live') {
        state.model.coupons![event.index].status = 'hide';
      } else {
        state.model.coupons![event.index].status = 'live';
      }
      emit(state.copyWith(status: OrderCouponListStatus.loadingHideStart));
      UpdateOrderCouponMetaInfoRequestModel param = UpdateOrderCouponMetaInfoRequestModel(status: state.model.coupons![event.index].status!);
      DioApiResponse response = await _couponRepository.updateOrderCouponMetaInfo(state.model.coupons![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: OrderCouponListStatus.loadingHideSuccess));
        } else {
          emit(state.copyWith(status: OrderCouponListStatus.loadingHideFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderCouponListStatus.loadingHideFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderCouponListStatus.loadingHideFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderCouponListDeleteEvent(OrderCouponListDeleteEvent event, Emitter<OrderCouponListState> emit) async {
    try {
      emit(state.copyWith(status: OrderCouponListStatus.loadingDeleteStart));
      final String userId = await _couponRepository.getUserId();
      DioApiResponse response = await _couponRepository.deleteOrderCoupon(state.model.coupons![event.index].id!, userId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(model: state.model, status: OrderCouponListStatus.loadingDeleteSuccess));
          state.model.coupons!.removeAt(event.index);
          emit(state.copyWith(model: state.model, status: state.model.coupons!.isEmpty ? OrderCouponListStatus.empty : OrderCouponListStatus.success));
        } else {
          emit(state.copyWith(status: OrderCouponListStatus.loadingDeleteFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderCouponListStatus.loadingDeleteFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderCouponListStatus.loadingDeleteFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
