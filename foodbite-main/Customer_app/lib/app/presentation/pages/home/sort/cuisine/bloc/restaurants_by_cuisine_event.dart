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

part of 'restaurants_by_cuisine_bloc.dart';

sealed class RestaurantsByCuisineEvent {}

final class RestaurantsByCuisineInitialEvent extends RestaurantsByCuisineEvent {
  final String name;
  final String slug;
  final String city;
  RestaurantsByCuisineInitialEvent({required this.name, required this.slug, required this.city});
}

final class RestaurantsByCuisineFavouriteEvent extends RestaurantsByCuisineEvent {
  final String id;
  final bool isFavourite;
  RestaurantsByCuisineFavouriteEvent({required this.id, required this.isFavourite});
}

final class RestaurantsByCuisineLoadMoreEvent extends RestaurantsByCuisineEvent {}

final class RestaurantsByCuisineHideEvent extends RestaurantsByCuisineEvent {
  final String id;
  RestaurantsByCuisineHideEvent({required this.id});
}

final class RestaurantsByCuisineRemoveRestaurantEvent extends RestaurantsByCuisineEvent {
  final String id;
  RestaurantsByCuisineRemoveRestaurantEvent({required this.id});
}

final class RestaurantsByCuisineUndoHideActionEvent extends RestaurantsByCuisineEvent {
  final String id;
  RestaurantsByCuisineUndoHideActionEvent({required this.id});
}
