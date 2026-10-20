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

part of 'filter_dining_with_category_bloc.dart';

sealed class FilterDiningWithCategoryEvent {}

final class FilterDiningWithCategoryInitialEvent extends FilterDiningWithCategoryEvent {
  final String name;
  final String slug;
  final String city;
  FilterDiningWithCategoryInitialEvent({required this.name, required this.slug, required this.city});
}

final class FilterDiningWithCategoryLoadMoreEvent extends FilterDiningWithCategoryEvent {}

final class FilterDiningWithCategoryFavouriteEvent extends FilterDiningWithCategoryEvent {
  final String id;
  final bool isFavourite;
  FilterDiningWithCategoryFavouriteEvent({required this.id, required this.isFavourite});
}

final class FilterDiningWithCategoryHideEvent extends FilterDiningWithCategoryEvent {
  final String id;
  FilterDiningWithCategoryHideEvent({required this.id});
}

final class FilterDiningWithCategoryRemoveRestaurantEvent extends FilterDiningWithCategoryEvent {
  final String id;
  FilterDiningWithCategoryRemoveRestaurantEvent({required this.id});
}

final class FilterDiningWithCategoryUndoHideActionEvent extends FilterDiningWithCategoryEvent {
  final String id;
  FilterDiningWithCategoryUndoHideActionEvent({required this.id});
}
