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

part of 'restaurants_by_localities_bloc.dart';

sealed class RestaurantsByLocalitiesEvent {}

final class RestaurantsByLocalitiesInitialEvent extends RestaurantsByLocalitiesEvent {
  final String from;
  final String slug;
  final String name;
  RestaurantsByLocalitiesInitialEvent({required this.from, required this.slug, required this.name});
}

final class RestaurantsByLocalitiesLoadMoreEvent extends RestaurantsByLocalitiesEvent {}

final class RestaurantsByLocalitiesFavouriteEvent extends RestaurantsByLocalitiesEvent {
  final String id;
  final bool isFavourite;
  RestaurantsByLocalitiesFavouriteEvent({required this.id, required this.isFavourite});
}

final class RestaurantsByLocalitiesHideEvent extends RestaurantsByLocalitiesEvent {
  final String id;
  RestaurantsByLocalitiesHideEvent({required this.id});
}

final class RestaurantsByLocalitiesRemoveRestaurantEvent extends RestaurantsByLocalitiesEvent {
  final String id;
  RestaurantsByLocalitiesRemoveRestaurantEvent({required this.id});
}

final class RestaurantsByLocalitiesUndoHideActionEvent extends RestaurantsByLocalitiesEvent {
  final String id;
  RestaurantsByLocalitiesUndoHideActionEvent({required this.id});
}
