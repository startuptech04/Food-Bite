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

part of 'table_order_detail_bloc.dart';

enum TableOrderDetailStatus { initial, loading, success, failure }

extension TableOrderDetailStatusX on TableOrderDetailStatus {
  bool get isInitial => this == TableOrderDetailStatus.initial;
  bool get isLoading => this == TableOrderDetailStatus.loading;
  bool get isSuccess => this == TableOrderDetailStatus.success;
  bool get isFailure => this == TableOrderDetailStatus.failure;
}

final class TableOrderDetailState {
  final String orderId;
  final TableOrderDetailModel model;
  final TableOrderDetailStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TableOrderDetailState({this.orderId = '', required this.model, this.status = TableOrderDetailStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  TableOrderDetailState copyWith({String? orderId, TableOrderDetailModel? model, TableOrderDetailStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return TableOrderDetailState(
      orderId: orderId ?? this.orderId,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
