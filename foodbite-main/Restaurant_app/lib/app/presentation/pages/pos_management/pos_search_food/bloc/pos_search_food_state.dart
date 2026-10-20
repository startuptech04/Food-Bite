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

part of 'pos_search_food_bloc.dart';

enum PosSearchFoodStatus { initial, empty, success, failure, initialCartUpdate, initialCartError, searchCartUpdate, searchCartError, cartError, customError }

extension PosSearchFoodStatusX on PosSearchFoodStatus {
  bool get isInitial => this == PosSearchFoodStatus.initial;
  bool get isSuccess => this == PosSearchFoodStatus.success;
  bool get isFailure => this == PosSearchFoodStatus.failure;
  bool get isEmpty => this == PosSearchFoodStatus.empty;
  bool get isInitialCartUpdate => this == PosSearchFoodStatus.initialCartUpdate;
  bool get isInitialCartError => this == PosSearchFoodStatus.initialCartError;
  bool get isSearchCartUpdate => this == PosSearchFoodStatus.searchCartUpdate;
  bool get isSearchCartError => this == PosSearchFoodStatus.searchCartError;
  bool get isCartError => this == PosSearchFoodStatus.cartError;
  bool get isCustomError => this == PosSearchFoodStatus.customError;
}

final class PosSearchFoodState {
  final String appLocale;
  final PosFoodSearchInitialResponseModel initialData;
  final PosFoodSearchResultResponseModel response;
  final PosSearchFoodStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PosSearchFoodState({this.appLocale = '', required this.initialData, required this.response, this.status = PosSearchFoodStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  PosSearchFoodState copyWith({
    String? appLocale,
    PosFoodSearchInitialResponseModel? initialData,
    PosFoodSearchResultResponseModel? response,
    PosSearchFoodStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return PosSearchFoodState(
      appLocale: appLocale ?? this.appLocale,
      initialData: initialData ?? this.initialData,
      response: response ?? this.response,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
