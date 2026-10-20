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
import 'package:user/app/core/models/dining_booking_list_response_model.dart';
import 'package:user/app/core/models/request/dining_booking_list_request_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:user/app/core/repositories/dining_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_booking_event.dart';
part 'dining_booking_state.dart';

class DiningBookingBloc extends Bloc<DiningBookingEvent, DiningBookingState> {
  final DiningRepository _diningRepository = DiningRepository();
  final AuthRepository _authRepository = AuthRepository();
  DiningBookingBloc()
    : super(
        DiningBookingState(
          pageSize: ApiRequestService.pageSize,
          model: DiningBookingListResponseModel(bookings: [], locale: ''),
        ),
      ) {
    on<DiningBookingInitialEvent>(_onDiningBookingInitialEvent);
    on<DiningBookingPullRefreshEvent>(_onDiningBookingPullRefreshEvent);
    on<DiningBookingLoadMoreBookingEvent>(_onDiningBookingLoadMoreBookingEvent);
  }

  FutureOr<void> _onDiningBookingInitialEvent(DiningBookingInitialEvent event, Emitter<DiningBookingState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "dining_booking_list"}, 'dining_booking_screen', 'dining_booking_screen');
      emit(state.copyWith(status: DiningBookingStatus.loading));
      final String userId = await _diningRepository.userId();
      if (userId.isNotEmpty) {
        emit(state.copyWith(isAuthorized: true));
        DiningBookingListRequestModel param = DiningBookingListRequestModel(uid: userId, page: state.currentPage, limit: state.pageSize);
        DioApiResponse response = await _diningRepository.getDiningBookingList(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          final String locale = await _authRepository.getLocale();
          DiningBookingListResponseModel bookingResponse = DiningBookingListResponseModel.fromJson(myMap, locale.toString());
          if (bookingResponse.bookings!.isEmpty) {
            emit(state.copyWith(status: DiningBookingStatus.empty));
          } else {
            emit(state.copyWith(status: DiningBookingStatus.success, model: bookingResponse));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DiningBookingStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } else {
        emit(state.copyWith(status: DiningBookingStatus.unAuthorized));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningBookingStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningBookingPullRefreshEvent(DiningBookingPullRefreshEvent event, Emitter<DiningBookingState> emit) async {
    try {
      emit(state.copyWith(status: DiningBookingStatus.loading, pageSize: ApiRequestService.pageSize));
      final String userId = await _diningRepository.userId();
      DiningBookingListRequestModel param = DiningBookingListRequestModel(page: state.currentPage, limit: state.pageSize, uid: userId);
      DioApiResponse response = await _diningRepository.getDiningBookingList(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        final String locale = await _authRepository.getLocale();
        DiningBookingListResponseModel bookingResponse = DiningBookingListResponseModel.fromJson(myMap, locale.toString());
        if (bookingResponse.bookings!.isEmpty) {
          emit(state.copyWith(status: DiningBookingStatus.empty));
        } else {
          emit(state.copyWith(status: DiningBookingStatus.success, model: bookingResponse));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningBookingStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningBookingStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningBookingLoadMoreBookingEvent(DiningBookingLoadMoreBookingEvent event, Emitter<DiningBookingState> emit) async {
    if (state.model.bookings!.length < state.model.totalResults! && !state.loadMore) {
      try {
        emit(state.copyWith(loadMore: true));
        final String userId = await _diningRepository.userId();
        DiningBookingListRequestModel param = DiningBookingListRequestModel(page: state.currentPage, limit: state.pageSize * 2, uid: userId);
        DioApiResponse response = await _diningRepository.getDiningBookingList(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          final String locale = await _authRepository.getLocale();
          DiningBookingListResponseModel bookingResponse = DiningBookingListResponseModel.fromJson(myMap, locale.toString());
          if (bookingResponse.bookings!.isEmpty) {
            emit(state.copyWith(status: DiningBookingStatus.empty, loadMore: false));
          } else {
            emit(state.copyWith(status: DiningBookingStatus.success, model: bookingResponse, loadMore: false, pageSize: state.pageSize * 2));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DiningBookingStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString(), loadMore: false));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DiningBookingStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
