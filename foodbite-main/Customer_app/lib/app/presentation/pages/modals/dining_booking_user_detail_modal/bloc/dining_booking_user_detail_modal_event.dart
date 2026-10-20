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

part of 'dining_booking_user_detail_modal_bloc.dart';

sealed class DiningBookingUserDetailModalEvent {}

final class DiningBookingUserDetailModalInitialEvent extends DiningBookingUserDetailModalEvent {
  final String userName;
  final String userCountryCode;
  final String userPhoneNumber;
  final String userEmail;
  DiningBookingUserDetailModalInitialEvent({required this.userName, required this.userCountryCode, required this.userPhoneNumber, required this.userEmail});
}

final class DiningBookingUserDetailModalNameChangedEvent extends DiningBookingUserDetailModalEvent {
  final String name;
  DiningBookingUserDetailModalNameChangedEvent({required this.name});
}

final class DiningBookingUserDetailModalNameUnfocusedEvent extends DiningBookingUserDetailModalEvent {}

final class DiningBookingUserDetailModalCountryCodeChangedEvent extends DiningBookingUserDetailModalEvent {
  final String flag;
  final String countryCode;
  DiningBookingUserDetailModalCountryCodeChangedEvent({required this.flag, required this.countryCode});
}

final class DiningBookingUserDetailModalNumberChangedEvent extends DiningBookingUserDetailModalEvent {
  final String number;
  DiningBookingUserDetailModalNumberChangedEvent({required this.number});
}

final class DiningBookingUserDetailModalNumberUnfocusedEvent extends DiningBookingUserDetailModalEvent {}

final class DiningBookingUserDetailModalEmailChangedEvent extends DiningBookingUserDetailModalEvent {
  final String email;
  DiningBookingUserDetailModalEmailChangedEvent({required this.email});
}

final class DiningBookingUserDetailModalEmailUnfocusedEvent extends DiningBookingUserDetailModalEvent {}

final class DiningBookingUserDetailModalSubmitEvent extends DiningBookingUserDetailModalEvent {}
