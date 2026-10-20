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

part of 'filter_restaurants_by_categories_bloc.dart';

sealed class FilterRestaurantsByCategoriesEvent {}

final class FilterRestaurantsByCategoriesInitialEvent extends FilterRestaurantsByCategoriesEvent {
  final String name;
  final String slug;
  final String city;
  FilterRestaurantsByCategoriesInitialEvent({required this.name, required this.slug, required this.city});
}

final class FilterRestaurantsByCategoriesFavouriteEvent extends FilterRestaurantsByCategoriesEvent {
  final String id;
  final bool isFavourite;
  FilterRestaurantsByCategoriesFavouriteEvent({required this.id, required this.isFavourite});
}

final class FilterRestaurantsByCategoriesLoadMoreEvent extends FilterRestaurantsByCategoriesEvent {}

final class FilterRestaurantsByCategoriesHideEvent extends FilterRestaurantsByCategoriesEvent {
  final String id;
  FilterRestaurantsByCategoriesHideEvent({required this.id});
}

final class FilterRestaurantsByCategoriesRemoveRestaurantEvent extends FilterRestaurantsByCategoriesEvent {
  final String id;
  FilterRestaurantsByCategoriesRemoveRestaurantEvent({required this.id});
}

final class FilterRestaurantsByCategoriesUndoHideActionEvent extends FilterRestaurantsByCategoriesEvent {
  final String id;
  FilterRestaurantsByCategoriesUndoHideActionEvent({required this.id});
}
