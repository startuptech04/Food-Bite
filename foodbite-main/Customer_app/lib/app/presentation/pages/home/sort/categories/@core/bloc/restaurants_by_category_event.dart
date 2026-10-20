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

part of 'restaurants_by_category_bloc.dart';

sealed class RestaurantsByCategoryEvent {}

final class RestaurantsByCategoryInitialEvent extends RestaurantsByCategoryEvent {
  final String name;
  final String slug;
  final String city;
  RestaurantsByCategoryInitialEvent({required this.name, required this.slug, required this.city});
}
