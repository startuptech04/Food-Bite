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

part of 'tiffin_subscription_food_bloc.dart';

enum TiffinSubscriptionFoodStatus { loading, success, failure, empty, saveItem }

extension TiffinSubscriptionFoodStatusX on TiffinSubscriptionFoodStatus {
  bool get isLoading => this == TiffinSubscriptionFoodStatus.loading;
  bool get isSuccess => this == TiffinSubscriptionFoodStatus.success;
  bool get isFailure => this == TiffinSubscriptionFoodStatus.failure;
  bool get isEmpty => this == TiffinSubscriptionFoodStatus.empty;
  bool get isSaveItem => this == TiffinSubscriptionFoodStatus.saveItem;
}

final class TiffinSubscriptionFoodState {
  final TiffinSubscriptionFoodListResponseModel model;
  final List<String> foodList;
  final TiffinSubscriptionFoodStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TiffinSubscriptionFoodState({required this.model, this.foodList = const [], this.status = TiffinSubscriptionFoodStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  TiffinSubscriptionFoodState copyWith({TiffinSubscriptionFoodListResponseModel? model, List<String>? foodList, TiffinSubscriptionFoodStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return TiffinSubscriptionFoodState(
      model: model ?? this.model,
      foodList: foodList ?? this.foodList,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
