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

part of 'food_list_bloc.dart';

enum FoodListStatus { loading, success, failure, empty, customError }

extension FoodListStatusX on FoodListStatus {
  bool get isLoading => this == FoodListStatus.loading;
  bool get isSuccess => this == FoodListStatus.success;
  bool get isFailure => this == FoodListStatus.failure;
  bool get isEmpty => this == FoodListStatus.empty;
  bool get isCustomError => this == FoodListStatus.customError;
}

final class FoodListState {
  final FoodListModel list;
  final FoodListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodListState({required this.list, this.status = FoodListStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  FoodListState copyWith({FoodListModel? list, FoodListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return FoodListState(list: list ?? this.list, status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage, statusCode: statusCode ?? this.statusCode);
  }
}
