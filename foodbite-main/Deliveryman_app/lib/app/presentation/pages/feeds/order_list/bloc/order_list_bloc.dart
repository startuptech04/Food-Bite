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
import 'package:driver/app/core/models/order_list_response_model.dart';
import 'package:driver/app/core/models/request/order_list_request_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/feeds_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final FeedsRepository _feedsRepository = FeedsRepository();
  final AuthRepository _authRepository = AuthRepository();
  OrderListBloc()
    : super(
        OrderListState(
          pageSize: ApiRequestService.pageSize,
          model: OrderListResponseModel(orders: [], success: false, locale: ''),
        ),
      ) {
    on<OrderListInitialEvent>(_onOrderListInitialEvent);
    on<OrderListPullRefreshEvent>(_onOrderListPullRefreshEvent);
    on<OrderListLoadMoreOrderEvent>(_onOrderListLoadMoreOrderEvent);
  }

  FutureOr<void> _onOrderListInitialEvent(OrderListInitialEvent event, Emitter<OrderListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "order_list"}, 'order_list_screen', 'order_list_screen');
      emit(state.copyWith(status: OrderListStatus.loading));
      OrderListRequestModel param = OrderListRequestModel(page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _feedsRepository.orderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListResponseModel orders = OrderListResponseModel.fromJson(myMap, locale.toString());
        for (var element in orders.orders!) {
          if (element.restaurant!.location!.coordinates!.isNotEmpty && element.deliveryAddressRaw!.location!.coordinates!.isNotEmpty) {
            double restaurantLatitude = element.restaurant!.location!.coordinates![1];
            double restaurantLongitude = element.restaurant!.location!.coordinates![0];
            double deliveryLatitude = element.deliveryAddressRaw!.location!.coordinates![1];
            double deliveryLongitude = element.deliveryAddressRaw!.location!.coordinates![0];
            double distanceInMeters = Geolocator.distanceBetween(restaurantLatitude, restaurantLongitude, deliveryLatitude, deliveryLongitude);
            if (orders.findMode! == 'km') {
              double distanceInKilometers = distanceInMeters / 1000;
              String distanceInString = double.parse(distanceInKilometers.toString()).toStringAsFixed(2);
              element.distance = double.parse(distanceInString.toString());
            } else {
              double distanceInMiles = distanceInMeters / 1609.34;
              String distanceInString = double.parse(distanceInMiles.toString()).toStringAsFixed(2);
              element.distance = double.parse(distanceInString.toString());
            }
          }
          element.deliveryFullAddress = '${element.deliveryAddressRaw!.flatHouse!} ${element.deliveryAddressRaw!.locality!} ${element.deliveryAddressRaw!.landmark!}';
        }
        emit(state.copyWith(status: orders.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty, model: orders));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderListPullRefreshEvent(OrderListPullRefreshEvent event, Emitter<OrderListState> emit) async {
    try {
      emit(state.copyWith(status: OrderListStatus.loading, pageSize: ApiRequestService.pageSize));
      OrderListRequestModel param = OrderListRequestModel(page: state.currentPage, limit: state.pageSize);
      DioApiResponse response = await _feedsRepository.orderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListResponseModel orders = OrderListResponseModel.fromJson(myMap, locale.toString());
        for (var element in orders.orders!) {
          if (element.restaurant!.location!.coordinates!.isNotEmpty && element.deliveryAddressRaw!.location!.coordinates!.isNotEmpty) {
            double restaurantLatitude = element.restaurant!.location!.coordinates![1];
            double restaurantLongitude = element.restaurant!.location!.coordinates![0];
            double deliveryLatitude = element.deliveryAddressRaw!.location!.coordinates![1];
            double deliveryLongitude = element.deliveryAddressRaw!.location!.coordinates![0];
            double distanceInMeters = Geolocator.distanceBetween(restaurantLatitude, restaurantLongitude, deliveryLatitude, deliveryLongitude);
            if (orders.findMode! == 'km') {
              double distanceInKilometers = distanceInMeters / 1000;
              String distanceInString = double.parse(distanceInKilometers.toString()).toStringAsFixed(2);
              element.distance = double.parse(distanceInString.toString());
            } else {
              double distanceInMiles = distanceInMeters / 1609.34;
              String distanceInString = double.parse(distanceInMiles.toString()).toStringAsFixed(2);
              element.distance = double.parse(distanceInString.toString());
            }
          }
          element.deliveryFullAddress = '${element.deliveryAddressRaw!.flatHouse!} ${element.deliveryAddressRaw!.locality!} ${element.deliveryAddressRaw!.landmark!}';
        }
        emit(state.copyWith(status: orders.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty, model: orders));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderListLoadMoreOrderEvent(OrderListLoadMoreOrderEvent event, Emitter<OrderListState> emit) async {
    if (state.model.orders!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        OrderListRequestModel param = OrderListRequestModel(page: state.currentPage, limit: state.pageSize * 2);
        DioApiResponse response = await _feedsRepository.orderList(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _authRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OrderListResponseModel orders = OrderListResponseModel.fromJson(myMap, locale.toString());
          for (var element in orders.orders!) {
            if (element.restaurant!.location!.coordinates!.isNotEmpty && element.deliveryAddressRaw!.location!.coordinates!.isNotEmpty) {
              double restaurantLatitude = element.restaurant!.location!.coordinates![1];
              double restaurantLongitude = element.restaurant!.location!.coordinates![0];
              double deliveryLatitude = element.deliveryAddressRaw!.location!.coordinates![1];
              double deliveryLongitude = element.deliveryAddressRaw!.location!.coordinates![0];
              double distanceInMeters = Geolocator.distanceBetween(restaurantLatitude, restaurantLongitude, deliveryLatitude, deliveryLongitude);
              if (orders.findMode! == 'km') {
                double distanceInKilometers = distanceInMeters / 1000;
                String distanceInString = double.parse(distanceInKilometers.toString()).toStringAsFixed(2);
                element.distance = double.parse(distanceInString.toString());
              } else {
                double distanceInMiles = distanceInMeters / 1609.34;
                String distanceInString = double.parse(distanceInMiles.toString()).toStringAsFixed(2);
                element.distance = double.parse(distanceInString.toString());
              }
            }
            element.deliveryFullAddress = '${element.deliveryAddressRaw!.flatHouse!} ${element.deliveryAddressRaw!.locality!} ${element.deliveryAddressRaw!.landmark!}';
          }
          emit(state.copyWith(status: orders.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty, model: orders, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString(), loadMore: false));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
