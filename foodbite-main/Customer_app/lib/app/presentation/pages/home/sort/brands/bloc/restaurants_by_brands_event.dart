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

part of 'restaurants_by_brands_bloc.dart';

sealed class RestaurantsByBrandsEvent {}

final class RestaurantsByBrandsInitialEvent extends RestaurantsByBrandsEvent {
  final String id;
  final String slug;
  final String name;
  final String cover;
  final String city;
  RestaurantsByBrandsInitialEvent({required this.id, required this.slug, required this.name, required this.cover, required this.city});
}

final class RestaurantsByBrandsFavouriteEvent extends RestaurantsByBrandsEvent {
  final String id;
  final bool isFavourite;
  RestaurantsByBrandsFavouriteEvent({required this.id, required this.isFavourite});
}

final class RestaurantsByBrandsHideEvent extends RestaurantsByBrandsEvent {
  final String id;
  RestaurantsByBrandsHideEvent({required this.id});
}

final class RestaurantsByBrandsRemoveRestaurantEvent extends RestaurantsByBrandsEvent {
  final String id;
  RestaurantsByBrandsRemoveRestaurantEvent({required this.id});
}

final class RestaurantsByBrandsUndoHideActionEvent extends RestaurantsByBrandsEvent {
  final String id;
  RestaurantsByBrandsUndoHideActionEvent({required this.id});
}
