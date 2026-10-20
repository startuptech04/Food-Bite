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

part of 'order_verification_modal_bloc.dart';

enum OrderVerificationModalStatus { initial, loaded, submit, failure, verified }

extension OrderVerificationModalStatusX on OrderVerificationModalStatus {
  bool get isInitial => this == OrderVerificationModalStatus.initial;
  bool get isLoaded => this == OrderVerificationModalStatus.loaded;
  bool get isSubmit => this == OrderVerificationModalStatus.submit;
  bool get isFailure => this == OrderVerificationModalStatus.failure;
  bool get isVerified => this == OrderVerificationModalStatus.verified;
}

final class OrderVerificationModalState {
  final String orderId;
  final String orderTo;
  final String customerOrderPin;
  final String driverOrderPin;
  final String otp;
  final String paymentMode;
  final double grandTotal;
  final bool isPaymentChecked;
  final OrderVerificationModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderVerificationModalState({
    this.orderId = '',
    this.orderTo = '',
    this.customerOrderPin = '',
    this.driverOrderPin = '',
    this.otp = '',
    this.paymentMode = '',
    this.grandTotal = 0.0,
    this.isPaymentChecked = false,
    this.status = OrderVerificationModalStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  OrderVerificationModalState copyWith({
    String? orderId,
    String? orderTo,
    String? customerOrderPin,
    String? driverOrderPin,
    String? otp,
    String? paymentMode,
    double? grandTotal,
    bool? isPaymentChecked,
    OrderVerificationModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return OrderVerificationModalState(
      orderId: orderId ?? this.orderId,
      orderTo: orderTo ?? this.orderTo,
      customerOrderPin: customerOrderPin ?? this.customerOrderPin,
      driverOrderPin: driverOrderPin ?? this.driverOrderPin,
      otp: otp ?? this.otp,
      paymentMode: paymentMode ?? this.paymentMode,
      grandTotal: grandTotal ?? this.grandTotal,
      isPaymentChecked: isPaymentChecked ?? this.isPaymentChecked,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
