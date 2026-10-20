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

part of 'dining_booking_request_modal_bloc.dart';

sealed class DiningBookingRequestModalEvent {}

final class DiningBookingRequestModalInitialEvent extends DiningBookingRequestModalEvent {
  final String instructions;
  DiningBookingRequestModalInitialEvent({required this.instructions});
}

final class DiningBookingRequestModalInstructionsChangeEvent extends DiningBookingRequestModalEvent {
  final String instructions;
  DiningBookingRequestModalInstructionsChangeEvent({required this.instructions});
}
