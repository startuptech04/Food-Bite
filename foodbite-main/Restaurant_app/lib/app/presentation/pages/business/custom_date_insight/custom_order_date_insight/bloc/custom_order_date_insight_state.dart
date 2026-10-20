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

part of 'custom_order_date_insight_bloc.dart';

enum CustomOrderDateInsightStatus { initial, loading, success, failure, empty }

extension CustomOrderDateInsightStatusX on CustomOrderDateInsightStatus {
  bool get isInitial => this == CustomOrderDateInsightStatus.initial;
  bool get isLoading => this == CustomOrderDateInsightStatus.loading;
  bool get isSuccess => this == CustomOrderDateInsightStatus.success;
  bool get isFailure => this == CustomOrderDateInsightStatus.failure;
  bool get isEmpty => this == CustomOrderDateInsightStatus.empty;
}

final class CustomOrderDateInsightState {
  final CustomDateInsightStartDateField startDate;
  final CustomDateInsightEndDateField endDate;
  final bool isValid;
  final OrderCustomDateBusinessInsightModel model;
  final CustomOrderDateInsightStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CustomOrderDateInsightState({
    this.startDate = const CustomDateInsightStartDateField.pure(),
    this.endDate = const CustomDateInsightEndDateField.pure(),
    this.isValid = false,
    required this.model,
    this.status = CustomOrderDateInsightStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  CustomOrderDateInsightState copyWith({
    CustomDateInsightStartDateField? startDate,
    CustomDateInsightEndDateField? endDate,
    bool? isValid,
    OrderCustomDateBusinessInsightModel? model,
    CustomOrderDateInsightStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return CustomOrderDateInsightState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isValid: isValid ?? this.isValid,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
