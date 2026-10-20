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

part of 'hide_restaurant_reason_modal_bloc.dart';

enum HideRestaurantReasonModalStatus { loading, success, failure, empty, submit, submitSuccess, submitFailed }

extension HideRestaurantReasonModalStatusX on HideRestaurantReasonModalStatus {
  bool get isLoading => this == HideRestaurantReasonModalStatus.loading;
  bool get isSuccess => this == HideRestaurantReasonModalStatus.success;
  bool get isFailure => this == HideRestaurantReasonModalStatus.failure;
  bool get isEmpty => this == HideRestaurantReasonModalStatus.empty;
  bool get isSubmit => this == HideRestaurantReasonModalStatus.submit;
  bool get isSubmitSuccess => this == HideRestaurantReasonModalStatus.submitSuccess;
  bool get isSubmitFailed => this == HideRestaurantReasonModalStatus.submitFailed;
}

final class HideRestaurantReasonModalState {
  final String restaurantId;
  final String restaurantName;
  final HideRestaurantReasonListModel list;
  final String reasonId;
  final HideRestaurantReasonModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const HideRestaurantReasonModalState({
    this.restaurantId = '',
    this.restaurantName = '',
    required this.list,
    this.reasonId = '',
    this.status = HideRestaurantReasonModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  HideRestaurantReasonModalState copyWith({
    String? restaurantId,
    String? restaurantName,
    HideRestaurantReasonListModel? list,
    String? reasonId,
    HideRestaurantReasonModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return HideRestaurantReasonModalState(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
