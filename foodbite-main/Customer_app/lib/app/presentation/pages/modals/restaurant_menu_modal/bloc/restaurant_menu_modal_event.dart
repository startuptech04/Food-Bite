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

part of 'restaurant_menu_modal_bloc.dart';

sealed class RestaurantMenuModalEvent {}

final class RestuarantMenuInitialEvent extends RestaurantMenuModalEvent {
  final String currentInView;
  final bool isDarkTheme;
  RestuarantMenuInitialEvent({required this.currentInView, required this.isDarkTheme});
}
