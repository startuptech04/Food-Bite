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

sealed class OrderVerificationModalEvent {}

final class OrderVerificationModalInitialEvent extends OrderVerificationModalEvent {
  final String orderId;
  final String orderTo;
  final String customerOrderPin;
  final String driverOrderPin;
  final String paymentMode;
  final double grandTotal;
  OrderVerificationModalInitialEvent({
    required this.orderId,
    required this.orderTo,
    required this.customerOrderPin,
    required this.driverOrderPin,
    required this.paymentMode,
    required this.grandTotal,
  });
}

final class OrderVerificationModalOTPChangeEvent extends OrderVerificationModalEvent {
  final String otp;
  OrderVerificationModalOTPChangeEvent({required this.otp});
}

final class OrderVerificationSubmitEvent extends OrderVerificationModalEvent {}

final class OrderVerificationModalCollectedCashEvent extends OrderVerificationModalEvent {}
