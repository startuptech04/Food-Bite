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

part of 'dining_booking_information_bloc.dart';

sealed class DiningBookingInformationEvent {}

final class DiningBookingInformationInitialEvent extends DiningBookingInformationEvent {
  final String bookingId;
  DiningBookingInformationInitialEvent({required this.bookingId});
}

final class DiningBookingInformationRestaurantDirectionEvent extends DiningBookingInformationEvent {}

final class DiningBookingInformationRestaurantCallEvent extends DiningBookingInformationEvent {}

final class DiningBookingInformationPaymentChangedEvent extends DiningBookingInformationEvent {
  final String id;
  DiningBookingInformationPaymentChangedEvent({required this.id});
}

final class DiningBookingInformationRepayBookingEvent extends DiningBookingInformationEvent {}

final class DiningBookingInformationCancelMyBookingEvent extends DiningBookingInformationEvent {
  final String reasonId;
  DiningBookingInformationCancelMyBookingEvent({required this.reasonId});
}
