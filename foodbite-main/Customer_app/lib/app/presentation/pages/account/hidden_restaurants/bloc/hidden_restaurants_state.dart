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

part of 'hidden_restaurants_bloc.dart';

enum HiddenRestaurantsStatus { loading, success, failure, empty, customError, unAuthorized }

extension HiddenRestaurantsStatusX on HiddenRestaurantsStatus {
  bool get isLoading => this == HiddenRestaurantsStatus.loading;
  bool get isSuccess => this == HiddenRestaurantsStatus.success;
  bool get isFailure => this == HiddenRestaurantsStatus.failure;
  bool get isEmpty => this == HiddenRestaurantsStatus.empty;
  bool get isCustomError => this == HiddenRestaurantsStatus.customError;
  bool get isUnAuthorized => this == HiddenRestaurantsStatus.unAuthorized;
}

final class HiddenRestaurantsState {
  final HiddenRestaurantListModel list;
  final HiddenRestaurantsStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const HiddenRestaurantsState({required this.list, this.status = HiddenRestaurantsStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  HiddenRestaurantsState copyWith({HiddenRestaurantListModel? list, HiddenRestaurantsStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return HiddenRestaurantsState(
      list: list ?? this.list,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
