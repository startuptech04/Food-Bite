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

part of 'pos_business_insight_bloc.dart';

enum PosBusinessInsightStatus { loading, success, failure }

extension PosBusinessInsightStatusX on PosBusinessInsightStatus {
  bool get isLoading => this == PosBusinessInsightStatus.loading;
  bool get isSuccess => this == PosBusinessInsightStatus.success;
  bool get isFailure => this == PosBusinessInsightStatus.failure;
}

final class PosBusinessInsightState {
  final String unit;
  final PosBusinessInsightModel model;
  final PosBusinessInsightStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const PosBusinessInsightState({this.unit = 'month', required this.model, this.status = PosBusinessInsightStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  PosBusinessInsightState copyWith({String? unit, PosBusinessInsightModel? model, PosBusinessInsightStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return PosBusinessInsightState(
      unit: unit ?? this.unit,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
