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

part of 'custom_table_order_date_insight_bloc.dart';

enum CustomTableOrderDateInsightStatus { initial, loading, success, failure, empty }

extension CustomTableOrderDateInsightStatusX on CustomTableOrderDateInsightStatus {
  bool get isInitial => this == CustomTableOrderDateInsightStatus.initial;
  bool get isLoading => this == CustomTableOrderDateInsightStatus.loading;
  bool get isSuccess => this == CustomTableOrderDateInsightStatus.success;
  bool get isFailure => this == CustomTableOrderDateInsightStatus.failure;
  bool get isEmpty => this == CustomTableOrderDateInsightStatus.empty;
}

final class CustomTableOrderDateInsightState {
  final CustomDateInsightStartDateField startDate;
  final CustomDateInsightEndDateField endDate;
  final bool isValid;
  final TableOrderCustomDateBusinessInsightModel model;
  final CustomTableOrderDateInsightStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CustomTableOrderDateInsightState({
    this.startDate = const CustomDateInsightStartDateField.pure(),
    this.endDate = const CustomDateInsightEndDateField.pure(),
    this.isValid = false,
    required this.model,
    this.status = CustomTableOrderDateInsightStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  CustomTableOrderDateInsightState copyWith({
    CustomDateInsightStartDateField? startDate,
    CustomDateInsightEndDateField? endDate,
    bool? isValid,
    TableOrderCustomDateBusinessInsightModel? model,
    CustomTableOrderDateInsightStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return CustomTableOrderDateInsightState(
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
