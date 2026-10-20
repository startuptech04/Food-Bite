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
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/models/request/review_list_request_model.dart';
import 'package:driver/app/core/models/review_list_response_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'review_list_event.dart';
part 'review_list_state.dart';

class ReviewListBloc extends Bloc<ReviewListEvent, ReviewListState> {
  final AuthRepository _authRepository = AuthRepository();
  ReviewListBloc()
    : super(
        ReviewListState(
          pageSize: ApiRequestService.pageSize,
          model: ReviewListResponseModel(reviews: [], totalPages: 0, totalResults: 0, limit: 0, page: 0, locale: ''),
        ),
      ) {
    on<ReviewListInitialEvent>(_onReviewListInitialEvent);
    on<ReviewListLoadMoreEvent>(_onReviewListLoadMoreEvent);
    on<ReviewListPullRefreshEvent>(_onReviewListPullRefreshEvent);
  }

  FutureOr<void> _onReviewListInitialEvent(ReviewListInitialEvent event, Emitter<ReviewListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "review_list"}, 'review_list_screen', 'review_list_screen');
      emit(state.copyWith(status: ReviewListStatus.loading));
      final String userId = await _authRepository.userId();
      ReviewListRequestModel param = ReviewListRequestModel(id: userId, page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _authRepository.getMyReviewList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ReviewListResponseModel reviews = ReviewListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: reviews.reviews!.isNotEmpty ? ReviewListStatus.success : ReviewListStatus.empty, model: reviews));
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
    if (state.model.reviews!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String userId = await _authRepository.userId();
        ReviewListRequestModel param = ReviewListRequestModel(page: state.currentPage, limit: state.pageSize * 2, id: userId);
        DioApiResponse response = await _authRepository.getMyReviewList(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _authRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ReviewListResponseModel reviews = ReviewListResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: reviews.reviews!.isNotEmpty ? ReviewListStatus.success : ReviewListStatus.empty, model: reviews, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: ReviewListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString(), loadMore: false));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: ReviewListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onReviewListPullRefreshEvent(ReviewListPullRefreshEvent event, Emitter<ReviewListState> emit) async {
    try {
      emit(state.copyWith(status: ReviewListStatus.loading, pageSize: ApiRequestService.pageSize));
      final String userId = await _authRepository.userId();
      ReviewListRequestModel param = ReviewListRequestModel(id: userId, page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _authRepository.getMyReviewList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ReviewListResponseModel reviews = ReviewListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: reviews.reviews!.isNotEmpty ? ReviewListStatus.success : ReviewListStatus.empty, model: reviews));
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
}
