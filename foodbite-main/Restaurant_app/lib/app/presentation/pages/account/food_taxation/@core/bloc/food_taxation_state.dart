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

part of 'food_taxation_bloc.dart';

enum FoodTaxationStatus { loading, success, empty, failure, deleteStarted, deleteSuccess, deleteFailed }

extension FoodTaxationStatusX on FoodTaxationStatus {
  bool get isLoading => this == FoodTaxationStatus.loading;
  bool get isSuccess => this == FoodTaxationStatus.success;
  bool get isFailure => this == FoodTaxationStatus.failure;
  bool get isEmpty => this == FoodTaxationStatus.empty;
  bool get isDeleteStarted => this == FoodTaxationStatus.deleteStarted;
  bool get isDeleteSuccess => this == FoodTaxationStatus.deleteSuccess;
  bool get isDeleteFailed => this == FoodTaxationStatus.deleteFailed;
}

final class FoodTaxationState {
  final FoodTaxationResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final FoodTaxationStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodTaxationState({required this.model, required this.pageSize, this.currentPage = 0, this.loadMore = false, this.status = FoodTaxationStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  FoodTaxationState copyWith({FoodTaxationResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, FoodTaxationStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return FoodTaxationState(
      model: model ?? this.model,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
