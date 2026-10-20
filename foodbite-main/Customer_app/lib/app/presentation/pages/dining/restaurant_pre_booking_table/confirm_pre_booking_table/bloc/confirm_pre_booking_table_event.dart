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

part of 'confirm_pre_booking_table_bloc.dart';

sealed class ConfirmPreBookingTableEvent {}

final class ConfirmPreBookingTableInitialEvent extends ConfirmPreBookingTableEvent {
  final String restaurant;
  final String selectedDate;
  final int selectedGuest;
  final String selectedSlot;
  final String selectedCoupon;
  ConfirmPreBookingTableInitialEvent({required this.restaurant, required this.selectedDate, required this.selectedGuest, required this.selectedSlot, required this.selectedCoupon});
}

final class ConfirmPreBookingPaymentChangeEvent extends ConfirmPreBookingTableEvent {
  final String id;
  ConfirmPreBookingPaymentChangeEvent({required this.id});
}

final class ConfirmPreBookingUserInfoChangeEvent extends ConfirmPreBookingTableEvent {
  final String name;
  final String countryCode;
  final String phoneNumber;
  final String email;
  ConfirmPreBookingUserInfoChangeEvent({required this.name, required this.countryCode, required this.phoneNumber, required this.email});
}

final class ConfirmPreBookingSpecialRequestChangeEvent extends ConfirmPreBookingTableEvent {
  final String instructions;
  ConfirmPreBookingSpecialRequestChangeEvent({required this.instructions});
}

final class ConfirmPreBookingSubmitEvent extends ConfirmPreBookingTableEvent {}
