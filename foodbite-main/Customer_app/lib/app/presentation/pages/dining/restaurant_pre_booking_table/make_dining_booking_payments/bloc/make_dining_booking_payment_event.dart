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

part of 'make_dining_booking_payment_bloc.dart';

sealed class MakeDiningBookingPaymentEvent {}

final class MakeDiningBookingPaymentInitialEvent extends MakeDiningBookingPaymentEvent {
  final String paymentId;
  MakeDiningBookingPaymentInitialEvent({required this.paymentId});
}

final class MakeDiningBookingPaymentResponseEvent extends MakeDiningBookingPaymentEvent {}
