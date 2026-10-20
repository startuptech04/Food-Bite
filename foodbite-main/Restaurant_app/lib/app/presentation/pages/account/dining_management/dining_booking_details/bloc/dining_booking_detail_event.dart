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

part of 'dining_booking_detail_bloc.dart';

sealed class DiningBookingDetailEvent {}

final class DiningBookingDetailInitialEvent extends DiningBookingDetailEvent {
  final String bookingId;
  DiningBookingDetailInitialEvent({required this.bookingId});
}

final class DiningBookingDetailRejectEvent extends DiningBookingDetailEvent {
  final String reasonId;
  DiningBookingDetailRejectEvent({required this.reasonId});
}

final class DiningBookingDetailAcceptEvent extends DiningBookingDetailEvent {}

final class DiningBookingDetailCallCustomerEvent extends DiningBookingDetailEvent {}
