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

sealed class OrderVerifyOtpEvent {}

final class OrderVerifyOtpInitialEvent extends OrderVerifyOtpEvent {
  final String orderId;
  final String customerPin;
  OrderVerifyOtpInitialEvent({required this.orderId, required this.customerPin});
}

final class OrderVerifyOtpChangeEvent extends OrderVerifyOtpEvent {
  final String otp;
  OrderVerifyOtpChangeEvent({required this.otp});
}

final class OrderVerifyOtpSubmitEvent extends OrderVerifyOtpEvent {}
