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

part of 'tiffin_subscription_food_bloc.dart';

sealed class TiffinSubscriptionFoodEvent {}

final class TiffinSubscriptionFoodInitialEvent extends TiffinSubscriptionFoodEvent {
  final List<String> foodList;
  TiffinSubscriptionFoodInitialEvent({required this.foodList});
}

final class TiffinSubscriptionFoodSelectEvent extends TiffinSubscriptionFoodEvent {
  final String foodId;
  TiffinSubscriptionFoodSelectEvent({required this.foodId});
}

final class TiffinSubscriptionFoodSaveEvent extends TiffinSubscriptionFoodEvent {}
