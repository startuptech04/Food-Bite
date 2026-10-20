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
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/models/api_status_response_model.dart';
import 'package:user/app/core/models/request/restaurant_review_request_model.dart';
import 'package:user/app/core/models/restaurant_review_response_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:user/app/core/repositories/restaurant_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'restaurants_review_event.dart';
part 'restaurants_review_state.dart';

class RestaurantsReviewBloc extends Bloc<RestaurantsReviewEvent, RestaurantsReviewState> {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  final AuthRepository _authRepository = AuthRepository();
  RestaurantsReviewBloc()
    : super(
        RestaurantsReviewState(
          pageSize: ApiRequestService.pageSize,
          detail: RestaurantReviewsResponseModel(locale: ''),
        ),
      ) {
    on<RestaurantsReviewInitialEvent>(_onRestaurantsReviewInitialEvent);
    on<RestaurantsReviewLoadMoreEvent>(_onRestaurantsReviewLoadMoreEvent);
  }

  FutureOr<void> _onRestaurantsReviewInitialEvent(RestaurantsReviewInitialEvent event, Emitter<RestaurantsReviewState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "restaurant_reviews"}, 'restaurant_${event.name}_review_screen', 'restaurant_${event.name}_review_screen');
      emit(state.copyWith(status: RestaurantsReviewStatus.loading, id: event.id, name: event.name, ratings: event.ratings));
      RestaurantReviewsRequestModel param = RestaurantReviewsRequestModel(id: event.id, page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _restaurantRepository.getRestaurantReviews(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: RestaurantsReviewStatus.empty));
        } else {
          final String locale = await _authRepository.getLocale();
          RestaurantReviewsResponseModel data = RestaurantReviewsResponseModel.fromJson(myMap, locale.toString());
          data.percentages!.sort((a, b) => a.star!.compareTo(b.star!));
          emit(state.copyWith(status: RestaurantsReviewStatus.success, detail: data));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: RestaurantsReviewStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: RestaurantsReviewStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onRestaurantsReviewLoadMoreEvent(RestaurantsReviewLoadMoreEvent event, Emitter<RestaurantsReviewState> emit) async {
    if (state.detail.reviews!.length < state.detail.totalResults! && !state.loadMore) {
      try {
        emit(state.copyWith(loadMore: true));
        RestaurantReviewsRequestModel param = RestaurantReviewsRequestModel(id: state.id, page: state.currentPage, limit: state.pageSize * 2);
        DioApiResponse response = await _restaurantRepository.getRestaurantReviews(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (!initialResponse.success!) {
            emit(state.copyWith(status: RestaurantsReviewStatus.empty, loadMore: false));
          } else {
            final String locale = await _authRepository.getLocale();
            RestaurantReviewsResponseModel data = RestaurantReviewsResponseModel.fromJson(myMap, locale.toString());
            data.percentages!.sort((a, b) => a.star!.compareTo(b.star!));
            emit(state.copyWith(status: RestaurantsReviewStatus.success, detail: data, loadMore: false, pageSize: state.pageSize * 2));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: RestaurantsReviewStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString(), loadMore: false));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: RestaurantsReviewStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
