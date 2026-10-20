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

part of 'orders_business_insight_bloc.dart';

enum OrdersBusinessInsightStatus { loading, success, failure }

extension OrdersBusinessInsightStatusX on OrdersBusinessInsightStatus {
  bool get isLoading => this == OrdersBusinessInsightStatus.loading;
  bool get isSuccess => this == OrdersBusinessInsightStatus.success;
  bool get isFailure => this == OrdersBusinessInsightStatus.failure;
}

final class OrdersBusinessInsightState {
  final String unit;
  final OrderBusinessInsightModel model;
  final OrdersBusinessInsightStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrdersBusinessInsightState({this.unit = 'month', required this.model, this.status = OrdersBusinessInsightStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OrdersBusinessInsightState copyWith({String? unit, OrderBusinessInsightModel? model, OrdersBusinessInsightStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OrdersBusinessInsightState(
      unit: unit ?? this.unit,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
