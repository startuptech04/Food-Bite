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

part of 'table_orders_business_insight_bloc.dart';

enum TableOrdersBusinessInsightStatus { loading, success, failure }

extension TableOrdersBusinessInsightStatusX on TableOrdersBusinessInsightStatus {
  bool get isLoading => this == TableOrdersBusinessInsightStatus.loading;
  bool get isSuccess => this == TableOrdersBusinessInsightStatus.success;
  bool get isFailure => this == TableOrdersBusinessInsightStatus.failure;
}

final class TableOrdersBusinessInsightState {
  final String unit;
  final TableOrderBusinessInsightModel model;
  final TableOrdersBusinessInsightStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TableOrdersBusinessInsightState({this.unit = 'month', required this.model, this.status = TableOrdersBusinessInsightStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  TableOrdersBusinessInsightState copyWith({String? unit, TableOrderBusinessInsightModel? model, TableOrdersBusinessInsightStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return TableOrdersBusinessInsightState(
      unit: unit ?? this.unit,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
