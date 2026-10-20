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

part of 'custom_pos_date_insight_bloc.dart';

enum CustomPosDateInsightStatus { initial, loading, success, failure, empty }

extension CustomPosDateInsightStatusX on CustomPosDateInsightStatus {
  bool get isInitial => this == CustomPosDateInsightStatus.initial;
  bool get isLoading => this == CustomPosDateInsightStatus.loading;
  bool get isSuccess => this == CustomPosDateInsightStatus.success;
  bool get isFailure => this == CustomPosDateInsightStatus.failure;
  bool get isEmpty => this == CustomPosDateInsightStatus.empty;
}

final class CustomPosDateInsightState {
  final CustomDateInsightStartDateField startDate;
  final CustomDateInsightEndDateField endDate;
  final bool isValid;
  final PosCustomDateBusinessInsightModel model;
  final CustomPosDateInsightStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CustomPosDateInsightState({
    this.startDate = const CustomDateInsightStartDateField.pure(),
    this.endDate = const CustomDateInsightEndDateField.pure(),
    this.isValid = false,
    required this.model,
    this.status = CustomPosDateInsightStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  CustomPosDateInsightState copyWith({
    CustomDateInsightStartDateField? startDate,
    CustomDateInsightEndDateField? endDate,
    bool? isValid,
    PosCustomDateBusinessInsightModel? model,
    CustomPosDateInsightStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return CustomPosDateInsightState(
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
