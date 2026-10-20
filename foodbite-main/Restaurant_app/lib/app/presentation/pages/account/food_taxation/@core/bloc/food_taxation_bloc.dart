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
import 'package:vendor/app/core/models/food_taxation_response_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_taxation_event.dart';
part 'food_taxation_state.dart';

class FoodTaxationBloc extends Bloc<FoodTaxationEvent, FoodTaxationState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  FoodTaxationBloc()
    : super(
        FoodTaxationState(
          model: FoodTaxationResponseModel(locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<FoodTaxationInitialEvent>(_onFoodTaxationInitialEvent);
    on<FoodTaxationDeleteEvent>(_onFoodTaxationDeleteEvent);
    on<FoodTaxationLoadMoreEvent>(_onFoodTaxationLoadMoreEvent);
  }

  FutureOr<void> _onFoodTaxationInitialEvent(FoodTaxationInitialEvent event, Emitter<FoodTaxationState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "food_taxation"}, 'food_taxation_screen', 'food_taxation_screen');
      emit(state.copyWith(status: FoodTaxationStatus.loading));
      final String vendorId = await _menuRepository.getVendorId();
      DioApiResponse response = await _menuRepository.getMyFoodTaxation(vendorId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        FoodTaxationResponseModel data = FoodTaxationResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.results!.isNotEmpty ? FoodTaxationStatus.success : FoodTaxationStatus.empty, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodTaxationStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodTaxationStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodTaxationDeleteEvent(FoodTaxationDeleteEvent event, Emitter<FoodTaxationState> emit) async {
    final int indexOfTaxation = state.model.results!.indexWhere((element) => element.id == event.id);
    if (indexOfTaxation != -1) {
      emit(state.copyWith(status: FoodTaxationStatus.deleteStarted));
      final String vendorId = await _menuRepository.getVendorId();
      DioApiResponse response = await _menuRepository.deleteFoodTaxation(event.id, vendorId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (data.success!) {
          emit(state.copyWith(status: FoodTaxationStatus.deleteSuccess));
          state.model.results!.removeAt(indexOfTaxation);
          bool isEmpty = false;
          if (state.model.results!.isEmpty) {
            isEmpty = true;
          }
          emit(state.copyWith(model: state.model, status: isEmpty ? FoodTaxationStatus.empty : FoodTaxationStatus.success));
        } else {
          emit(state.copyWith(status: FoodTaxationStatus.deleteFailed, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodTaxationStatus.deleteFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    }
  }

  FutureOr<void> _onFoodTaxationLoadMoreEvent(FoodTaxationLoadMoreEvent event, Emitter<FoodTaxationState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _menuRepository.getVendorId();
        DioApiResponse response = await _menuRepository.getMyFoodTaxation(vendorId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          FoodTaxationResponseModel data = FoodTaxationResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: data.results!.isNotEmpty ? FoodTaxationStatus.success : FoodTaxationStatus.empty, model: data, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: FoodTaxationStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: FoodTaxationStatus.failure, loadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
