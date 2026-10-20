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

part of 'order_verify_otp_bloc.dart';

enum OrderVerifyOtpStatus { initial, loaded, submit, failure, verified }

extension OrderVerifyOtpStatusX on OrderVerifyOtpStatus {
  bool get isInitial => this == OrderVerifyOtpStatus.initial;
  bool get isLoaded => this == OrderVerifyOtpStatus.loaded;
  bool get isSubmit => this == OrderVerifyOtpStatus.submit;
  bool get isFailure => this == OrderVerifyOtpStatus.failure;
  bool get isVerified => this == OrderVerifyOtpStatus.verified;
}

final class OrderVerifyOtpState {
  final String orderId;
  final String customerOrderPin;
  final String otp;
  final OrderVerifyOtpStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderVerifyOtpState({this.orderId = '', this.customerOrderPin = '', this.otp = '', this.status = OrderVerifyOtpStatus.initial, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OrderVerifyOtpState copyWith({String? orderId, String? customerOrderPin, String? otp, OrderVerifyOtpStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OrderVerifyOtpState(
      orderId: orderId ?? this.orderId,
      customerOrderPin: customerOrderPin ?? this.customerOrderPin,
      otp: otp ?? this.otp,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
