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

part of 'register_request_payment_bloc.dart';

sealed class RegisterRequestPaymentEvent {}

final class RegisterRequestPaymentInitialEvent extends RegisterRequestPaymentEvent {
  final String paymentId;
  RegisterRequestPaymentInitialEvent({required this.paymentId});
}

final class RegisterRequestPaymentResponseEvent extends RegisterRequestPaymentEvent {}
