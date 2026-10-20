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

part of 'restaurant_pre_booking_table_bloc.dart';

sealed class RestaurantPreBookingTableEvent {}

final class RestaurantPreBookingTableInitialEvent extends RestaurantPreBookingTableEvent {
  final String restaurant;
  final String restaurantName;
  final String restaurantSlug;
  RestaurantPreBookingTableInitialEvent({required this.restaurant, required this.restaurantName, required this.restaurantSlug});
}

final class RestaurantPreBookingChangeDateEvent extends RestaurantPreBookingTableEvent {
  final String dateFormat;
  RestaurantPreBookingChangeDateEvent({required this.dateFormat});
}

final class RestaurantPreBookingChangeGuestEvent extends RestaurantPreBookingTableEvent {
  final int guest;
  RestaurantPreBookingChangeGuestEvent({required this.guest});
}

final class RestaurantPreBookingChangeMealTimeEvent extends RestaurantPreBookingTableEvent {
  final int mealIndex;
  RestaurantPreBookingChangeMealTimeEvent({required this.mealIndex});
}

final class RestaurantPreBookingSaveSlotEvent extends RestaurantPreBookingTableEvent {
  final String slot;
  RestaurantPreBookingSaveSlotEvent({required this.slot});
}

final class RestaurantPreBookingSaveCouponEvent extends RestaurantPreBookingTableEvent {
  final String couponId;
  RestaurantPreBookingSaveCouponEvent({required this.couponId});
}

final class RestaurantPreBookingTableGuestLoginEvent extends RestaurantPreBookingTableEvent {}

final class RestaurantPreBookingTableSubmitEvent extends RestaurantPreBookingTableEvent {}
