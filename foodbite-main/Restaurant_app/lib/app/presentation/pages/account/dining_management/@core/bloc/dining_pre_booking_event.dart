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

part of 'dining_pre_booking_bloc.dart';

sealed class DiningPreBookingEvent {}

final class DiningPreBookingInitialEvent extends DiningPreBookingEvent {}

final class DiningPreBookingTabChangeEvent extends DiningPreBookingEvent {
  final String key;
  DiningPreBookingTabChangeEvent({required this.key});
}

final class DiningPreBookingLoadMoreBookingEvent extends DiningPreBookingEvent {}

final class DiningPreBookingPullRefreshEvent extends DiningPreBookingEvent {}

final class DiningPreBookingAcceptNewBookingEvent extends DiningPreBookingEvent {
  final int bookingIndex;
  DiningPreBookingAcceptNewBookingEvent({required this.bookingIndex});
}

final class DiningPreBookingRejectNewBookingEvent extends DiningPreBookingEvent {
  final int bookingIndex;
  final String reasonId;
  DiningPreBookingRejectNewBookingEvent({required this.bookingIndex, required this.reasonId});
}

final class DiningPreBookingCompleteBookingEvent extends DiningPreBookingEvent {
  final int bookingIndex;
  DiningPreBookingCompleteBookingEvent({required this.bookingIndex});
}
