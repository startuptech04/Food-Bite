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

part of 'completed_order_detail_bloc.dart';

enum CompletedOrderDetailStatus { loading, success, failure }

extension CompletedOrderDetailStatusX on CompletedOrderDetailStatus {
  bool get isLoading => this == CompletedOrderDetailStatus.loading;
  bool get isSuccess => this == CompletedOrderDetailStatus.success;
  bool get isFailure => this == CompletedOrderDetailStatus.failure;
}

final class CompletedOrderDetailState {
  final String orderId;
  final String orderNo;
  final OrderDetailResponseModel orderDetail;
  final CompletedOrderDetailStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CompletedOrderDetailState({this.orderId = '', this.orderNo = '', required this.orderDetail, this.status = CompletedOrderDetailStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  CompletedOrderDetailState copyWith({String? orderId, String? orderNo, OrderDetailResponseModel? orderDetail, CompletedOrderDetailStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return CompletedOrderDetailState(
      orderId: orderId ?? this.orderId,
      orderNo: orderNo ?? this.orderNo,
      orderDetail: orderDetail ?? this.orderDetail,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
