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

part of 'cart_bloc.dart';

sealed class CartEvent {}

final class CartInitialEvent extends CartEvent {}

final class CartRefreshEvent extends CartEvent {}

final class CartQuantityEvent extends CartEvent {
  final String action;
  final int summaryIndex;
  final int foodIndex;
  CartQuantityEvent({required this.action, required this.summaryIndex, required this.foodIndex});
}

final class CartOnCheckoutEvent extends CartEvent {
  final String name;
  final String restaurant;
  CartOnCheckoutEvent({required this.name, required this.restaurant});
}

final class CartGuestCheckoutEvent extends CartEvent {}
