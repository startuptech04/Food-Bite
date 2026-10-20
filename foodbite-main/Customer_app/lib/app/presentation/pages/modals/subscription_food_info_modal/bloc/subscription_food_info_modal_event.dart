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

part of 'subscription_food_info_modal_bloc.dart';

sealed class SubscriptionFoodInfoModalEvent {}

final class SubscriptionFoodInfoInitialEvent extends SubscriptionFoodInfoModalEvent {
  final String id;
  final String data;
  final bool canAddAddons;
  final bool canAddVariations;
  final int totalOrders;
  final String inCart;
  SubscriptionFoodInfoInitialEvent({required this.id, required this.data, required this.canAddAddons, required this.canAddVariations, required this.totalOrders, required this.inCart});
}

final class SubscriptionFoodInfoModalAddonsEvent extends SubscriptionFoodInfoModalEvent {
  final int index;
  SubscriptionFoodInfoModalAddonsEvent({required this.index});
}

final class SubscriptionFoodInfoModalVariationOptionEvent extends SubscriptionFoodInfoModalEvent {
  final int vIndex;
  final int oIndex;
  final String type;
  SubscriptionFoodInfoModalVariationOptionEvent({required this.vIndex, required this.oIndex, required this.type});
}

final class SubscriptionFoodInfoModalSaveEvent extends SubscriptionFoodInfoModalEvent {}

final class SubscriptionFoodInfoModalShaveEvent extends SubscriptionFoodInfoModalEvent {}
