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

part of 'bottom_tab_navigation_bloc.dart';

sealed class BottomTabNavigationEvent {}

class BottomNavigationTabInitialEvent extends BottomTabNavigationEvent {
  final int tabIndex;
  BottomNavigationTabInitialEvent({required this.tabIndex});
}

class BottomNavigationTabChange extends BottomTabNavigationEvent {
  final int tabIndex;
  BottomNavigationTabChange({required this.tabIndex});
}

final class BottomNavigationRefreshCartEvent extends BottomTabNavigationEvent {}

final class BottomNavigationRemoveCartItemByRestaurant extends BottomTabNavigationEvent {
  final String restaurantId;
  BottomNavigationRemoveCartItemByRestaurant({required this.restaurantId});
}

final class BottomTabNavigationOnCheckoutEvent extends BottomTabNavigationEvent {
  final String name;
  final String restaurant;
  BottomTabNavigationOnCheckoutEvent({required this.name, required this.restaurant});
}

final class BottomTabNavigationGuestCheckoutEvent extends BottomTabNavigationEvent {}

final class BottomTabNavigationChangeInitialEvent extends BottomTabNavigationEvent {}
