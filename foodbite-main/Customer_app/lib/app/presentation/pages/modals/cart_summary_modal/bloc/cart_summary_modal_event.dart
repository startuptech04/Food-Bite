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

part of 'cart_summary_modal_bloc.dart';

sealed class CartSummaryModalEvent {}

final class CartSummaryModalInitialEvent extends CartSummaryModalEvent {}

final class CartSummaryModalRemoveCartItemByRestaurantEvent extends CartSummaryModalEvent {
  final String restaurantId;
  CartSummaryModalRemoveCartItemByRestaurantEvent({required this.restaurantId});
}

final class CartSummaryModalClearCartEvent extends CartSummaryModalEvent {}

final class CartSummaryModalOnCheckoutEvent extends CartSummaryModalEvent {
  final String name;
  final String restaurant;
  CartSummaryModalOnCheckoutEvent({required this.name, required this.restaurant});
}

final class CartSummaryModalGuestCheckoutEvent extends CartSummaryModalEvent {}

final class CartSummaryModalChangeInitialEvent extends CartSummaryModalEvent {}
