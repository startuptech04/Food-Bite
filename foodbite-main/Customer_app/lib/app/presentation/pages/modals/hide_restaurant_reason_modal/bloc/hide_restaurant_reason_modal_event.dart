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

part of 'hide_restaurant_reason_modal_bloc.dart';

sealed class HideRestaurantReasonModalEvent {}

final class HideRestaurantReasonModalInitialEvent extends HideRestaurantReasonModalEvent {
  final String restaurantId;
  final String restaurantName;
  HideRestaurantReasonModalInitialEvent({required this.restaurantId, required this.restaurantName});
}

final class HideRestaurantReasonSelectEvent extends HideRestaurantReasonModalEvent {
  final String reasonId;
  HideRestaurantReasonSelectEvent({required this.reasonId});
}

final class HideRestaurantReasonSubmitEvent extends HideRestaurantReasonModalEvent {}
