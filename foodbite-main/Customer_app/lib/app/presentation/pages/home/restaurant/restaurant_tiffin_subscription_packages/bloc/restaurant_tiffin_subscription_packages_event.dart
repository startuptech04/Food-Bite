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

part of 'restaurant_tiffin_subscription_packages_bloc.dart';

sealed class RestaurantTiffinSubscriptionPackagesEvent {}

final class RestaurantTiffinSubscriptionPackagesInitialEvent extends RestaurantTiffinSubscriptionPackagesEvent {
  final String restaurant;
  final String restaurantName;
  RestaurantTiffinSubscriptionPackagesInitialEvent({required this.restaurant, required this.restaurantName});
}

final class RestaurantTiffinSubscriptionPackagesLoadMoreEvent extends RestaurantTiffinSubscriptionPackagesEvent {}
