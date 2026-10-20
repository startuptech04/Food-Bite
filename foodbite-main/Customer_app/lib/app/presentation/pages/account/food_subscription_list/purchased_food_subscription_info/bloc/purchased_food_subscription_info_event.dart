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

part of 'purchased_food_subscription_info_bloc.dart';

sealed class PurchasedFoodSubscriptionInfoEvent {}

final class PurchasedFoodSubscriptionInfoInitialEvent extends PurchasedFoodSubscriptionInfoEvent {
  final String purchaseId;
  PurchasedFoodSubscriptionInfoInitialEvent({required this.purchaseId});
}

final class PurchasedFoodSubscriptionInfoRepayPackageEvent extends PurchasedFoodSubscriptionInfoEvent {}

final class PurchasedFoodSubscriptionInfoPaymentChangedEvent extends PurchasedFoodSubscriptionInfoEvent {
  final String id;
  PurchasedFoodSubscriptionInfoPaymentChangedEvent({required this.id});
}

final class PurchasedFoodSubscriptionInfoCancelPackageEvent extends PurchasedFoodSubscriptionInfoEvent {
  final String reasonId;
  PurchasedFoodSubscriptionInfoCancelPackageEvent({required this.reasonId});
}

final class PurchasedFoodSubscriptionInfoCallRestaurantEvent extends PurchasedFoodSubscriptionInfoEvent {}
