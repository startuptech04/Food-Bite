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

part of 'filter_foods_by_category_bloc.dart';

sealed class FilterFoodsByCategoryEvent {}

final class FilterFoodsByCategoryInitialEvent extends FilterFoodsByCategoryEvent {
  final String name;
  final String slug;
  final String city;
  FilterFoodsByCategoryInitialEvent({required this.name, required this.slug, required this.city});
}

final class FilterFoodsByCategoryFavouriteEvent extends FilterFoodsByCategoryEvent {
  final String id;
  final bool isFavourite;
  FilterFoodsByCategoryFavouriteEvent({required this.id, required this.isFavourite});
}

final class FilterFoodsByCategoryLoadMoreEvent extends FilterFoodsByCategoryEvent {}

final class FilterFoodsVariationModalResponseEvent extends FilterFoodsByCategoryEvent {
  final String id;
  final FoodVariationModalResponseDataModel data;
  FilterFoodsVariationModalResponseEvent({required this.id, required this.data});
}

final class FilterFoodsFoodQuantityDecreaseEvent extends FilterFoodsByCategoryEvent {
  final String id;
  FilterFoodsFoodQuantityDecreaseEvent({required this.id});
}

final class FilterFoodsFoodQuantityIncreaseEvent extends FilterFoodsByCategoryEvent {
  final String id;
  FilterFoodsFoodQuantityIncreaseEvent({required this.id});
}

final class FilterFoodsAddCartEvent extends FilterFoodsByCategoryEvent {
  final String id;
  FilterFoodsAddCartEvent({required this.id});
}

final class FilterFoodsRepeatFoodOrderResponseEvent extends FilterFoodsByCategoryEvent {
  final String id;
  final RepeatQuantityModalResponseModel data;
  FilterFoodsRepeatFoodOrderResponseEvent({required this.id, required this.data});
}

final class FilterFoodsFoodVariationModalRepeatResponseEvent extends FilterFoodsByCategoryEvent {
  final String id;
  final FoodVariationModalResponseDataModel data;
  FilterFoodsFoodVariationModalRepeatResponseEvent({required this.id, required this.data});
}

final class FilterFoodsFoodModalResponseEvent extends FilterFoodsByCategoryEvent {
  final String id;
  final FoodInfoModalResponseModel response;
  FilterFoodsFoodModalResponseEvent({required this.id, required this.response});
}
