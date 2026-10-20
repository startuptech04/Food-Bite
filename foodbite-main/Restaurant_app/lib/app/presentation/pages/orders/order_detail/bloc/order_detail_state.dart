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

enum OrderDetailStatus {
  loading,
  success,
  failure,
  customError,
  callCustomer,
  callCustomerSuccess,
  callDeliveryman,
  callDeliverymanSuccess,
  rejectOrder,
  rejectOrderSuccess,
  acceptOrder,
  acceptOrderSuccess,
  readyOrder,
  readyOrderSuccess,
  handoverOrder,
  handoverOrderSuccess,
}

extension OrderDetailStatusX on OrderDetailStatus {
  bool get isLoading => this == OrderDetailStatus.loading;
  bool get isSuccess => this == OrderDetailStatus.success;
  bool get isFailure => this == OrderDetailStatus.failure;
  bool get isCustomError => this == OrderDetailStatus.customError;
  bool get isCallCustomer => this == OrderDetailStatus.callCustomer;
  bool get isCallCustomerSucces => this == OrderDetailStatus.callCustomerSuccess;
  bool get isCallDeliveryman => this == OrderDetailStatus.callDeliveryman;
  bool get isCallDeliverymanSuccess => this == OrderDetailStatus.callDeliverymanSuccess;
  bool get isRejectOrder => this == OrderDetailStatus.rejectOrder;
  bool get isRejectOrderSuccess => this == OrderDetailStatus.rejectOrderSuccess;
  bool get isAcceptOrder => this == OrderDetailStatus.acceptOrder;
  bool get isAcceptOrderSuccess => this == OrderDetailStatus.acceptOrderSuccess;
  bool get isReadyOrder => this == OrderDetailStatus.readyOrder;
  bool get isReadyOrderSuccess => this == OrderDetailStatus.readyOrderSuccess;
  bool get isHandoverOrder => this == OrderDetailStatus.handoverOrder;
  bool get isHandoverOrderSuccess => this == OrderDetailStatus.handoverOrderSuccess;
}

final class OrderDetailState {
  final String orderId;
  final int orderNo;
  final OrderDetailResponseModel model;
  final double bottomHeight;
  final OrderDetailStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderDetailState({this.orderId = '', this.orderNo = 0, required this.model, this.bottomHeight = 0.0, this.status = OrderDetailStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OrderDetailState copyWith({String? orderId, int? orderNo, OrderDetailResponseModel? model, double? bottomHeight, OrderDetailStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OrderDetailState(
      orderId: orderId ?? this.orderId,
      orderNo: orderNo ?? this.orderNo,
      model: model ?? this.model,
      bottomHeight: bottomHeight ?? this.bottomHeight,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
