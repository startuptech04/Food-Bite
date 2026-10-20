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

part of 'order_detail_bloc.dart';

enum OrderDetailStatus { loading, success, failure, customError, acceptOrder, acceptOrderSuccess, completeOrder, completeOrderSuccess }

extension OrderDetailStatusX on OrderDetailStatus {
  bool get isLoading => this == OrderDetailStatus.loading;
  bool get isSuccess => this == OrderDetailStatus.success;
  bool get isFailure => this == OrderDetailStatus.failure;
  bool get isCustomError => this == OrderDetailStatus.customError;
  bool get isAcceptOrder => this == OrderDetailStatus.acceptOrder;
  bool get isAcceptOrderSuccess => this == OrderDetailStatus.acceptOrderSuccess;
  bool get isCompleteOrder => this == OrderDetailStatus.completeOrder;
  bool get isCompleteOrderSuccess => this == OrderDetailStatus.completeOrderSuccess;
}

final class OrderDetailState {
  final String orderId;
  final OrderDetailResponseModel model;
  final OrderDetailStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderDetailState({this.orderId = '', required this.model, this.status = OrderDetailStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OrderDetailState copyWith({String? orderId, OrderDetailResponseModel? model, OrderDetailStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OrderDetailState(
      orderId: orderId ?? this.orderId,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
