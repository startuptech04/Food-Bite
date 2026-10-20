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

part of 'table_order_bloc.dart';

enum TableOrderStatus { loading, success, failure, empty }

extension TableOrderStatusX on TableOrderStatus {
  bool get isLoading => this == TableOrderStatus.loading;
  bool get isSuccess => this == TableOrderStatus.success;
  bool get isFailure => this == TableOrderStatus.failure;
  bool get isEmpty => this == TableOrderStatus.empty;
}

final class TableOrderState {
  final RestaurantTableListModel model;
  final TableOrderStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TableOrderState({required this.model, this.status = TableOrderStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  TableOrderState copyWith({RestaurantTableListModel? model, TableOrderStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return TableOrderState(model: model ?? this.model, status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage, statusCode: statusCode ?? this.statusCode);
  }
}
