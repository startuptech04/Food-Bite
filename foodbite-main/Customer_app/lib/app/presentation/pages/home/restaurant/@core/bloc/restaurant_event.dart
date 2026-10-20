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

part of 'restaurant_bloc.dart';

sealed class RestaurantEvent {}

final class RestaurantInitialEvent extends RestaurantEvent {
  final String id;
  final String slug;
  final String name;
  RestaurantInitialEvent({required this.id, required this.slug, required this.name});
}

final class RestaurantFavouriteEvent extends RestaurantEvent {}

final class RestaurantShareEvent extends RestaurantEvent {}

final class RestaurantVariationModalResponseEvent extends RestaurantEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final FoodVariationModalResponseDataModel data;
  RestaurantVariationModalResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}

final class RestaurantFoodQuantityDecreaseEvent extends RestaurantEvent {
  final String id;
  final String from;
  final int categoryIndex;
  RestaurantFoodQuantityDecreaseEvent({required this.id, required this.from, required this.categoryIndex});
}

final class RestaurantFoodQuantityIncreaseEvent extends RestaurantEvent {
  final String id;
  final String from;
  final int categoryIndex;
  RestaurantFoodQuantityIncreaseEvent({required this.id, required this.from, required this.categoryIndex});
}

final class RestaurantAddCartEvent extends RestaurantEvent {
  final String id;
  final String from;
  final int categoryIndex;
  RestaurantAddCartEvent({required this.id, required this.from, required this.categoryIndex});
}

final class RestaurantRepeatFoodOrderResponseEvent extends RestaurantEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final RepeatQuantityModalResponseModel data;
  RestaurantRepeatFoodOrderResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}

final class RestaurantFoodVariationModalRepeatResponseEvent extends RestaurantEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final FoodVariationModalResponseDataModel data;
  RestaurantFoodVariationModalRepeatResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.data});
}

final class RestaurantFoodModalResponseEvent extends RestaurantEvent {
  final String id;
  final String from;
  final int categoryIndex;
  final FoodInfoModalResponseModel response;
  RestaurantFoodModalResponseEvent({required this.id, required this.from, required this.categoryIndex, required this.response});
}

final class RestaurantToggleRecommendedViewEvent extends RestaurantEvent {}

final class RestaurantToggleCustomCategoryViewEvent extends RestaurantEvent {
  final int categoryIndex;
  RestaurantToggleCustomCategoryViewEvent({required this.categoryIndex});
}

final class RestaurantToggleMainCategoryViewEvent extends RestaurantEvent {
  final int categoryIndex;
  RestaurantToggleMainCategoryViewEvent({required this.categoryIndex});
}

final class RestaurantScrollToCategory extends RestaurantEvent {
  final String categoryId;
  RestaurantScrollToCategory({required this.categoryId});
}

final class RestaurantRefreshCartEvent extends RestaurantEvent {}

final class RestaurantRefreshFoodFavEvent extends RestaurantEvent {
  final List<String> inFavList;
  RestaurantRefreshFoodFavEvent({required this.inFavList});
}

final class RestaurantHideEvent extends RestaurantEvent {}

final class RestaurantRefreshFavEvent extends RestaurantEvent {}

final class RestaurantRefreshCartDataEvent extends RestaurantEvent {}

final class RestaurantCheckoutEvent extends RestaurantEvent {}

final class RestaurantChangeInitialEvent extends RestaurantEvent {}

final class RestaurantGuestCheckoutEvent extends RestaurantEvent {}

final class RestaurantClearCampaignEvent extends RestaurantEvent {}
