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
import 'package:vendor/app/core/models/request/restaurant_review_list_request_model.dart';
import 'package:vendor/app/core/models/restaurant_review_response_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'review_list_event.dart';
part 'review_list_state.dart';

class ReviewListBloc extends Bloc<ReviewListEvent, ReviewListState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ReviewListBloc()
    : super(
        ReviewListState(
          pageSize: ApiRequestService.pageSize,
          detail: RestaurantReviewsResponseModel(locale: ''),
        ),
      ) {
    on<ReviewListInitialEvent>(_onReviewListInitialEvent);
    on<ReviewListLoadMoreEvent>(_onReviewListLoadMoreEvent);
  }

  FutureOr<void> _onReviewListInitialEvent(ReviewListInitialEvent event, Emitter<ReviewListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "report_emergency_form"}, 'report_emergency_screen', 'report_emergency_screen');
      emit(state.copyWith(status: ReviewListStatus.loading));
      final String vendorId = await _orderRepository.getVendorId();
      RestaurantReviewListRequestModel param = RestaurantReviewListRequestModel(id: vendorId, page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _orderRepository.getRestaurantReviewList(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: ReviewListStatus.empty));
        } else {
          final String locale = await _accountRepository.getLocale();
          RestaurantReviewsResponseModel data = RestaurantReviewsResponseModel.fromJson(myMap, locale.toString());
          data.percentages!.sort((a, b) => a.star!.compareTo(b.star!));
          emit(state.copyWith(status: ReviewListStatus.success, detail: data));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: ReviewListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ReviewListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onReviewListLoadMoreEvent(ReviewListLoadMoreEvent event, Emitter<ReviewListState> emit) async {
    if (state.detail.reviews!.length < state.detail.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _orderRepository.getVendorId();
        RestaurantReviewListRequestModel param = RestaurantReviewListRequestModel(id: vendorId, page: state.currentPage, limit: state.pageSize * 2);
        DioApiResponse response = await _orderRepository.getRestaurantReviewList(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (!initialResponse.success!) {
            emit(state.copyWith(status: ReviewListStatus.empty, loadMore: false));
          } else {
            final String locale = await _accountRepository.getLocale();
            RestaurantReviewsResponseModel data = RestaurantReviewsResponseModel.fromJson(myMap, locale.toString());
            data.percentages!.sort((a, b) => a.star!.compareTo(b.star!));
            emit(state.copyWith(status: ReviewListStatus.success, detail: data, loadMore: false, pageSize: state.pageSize * 2));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ReviewListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), loadMore: false, extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ReviewListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
