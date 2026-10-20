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

part of 'food_search_bloc.dart';

sealed class FoodSearchEvent {}

final class FoodSearchInitialEvent extends FoodSearchEvent {
  final String id;
  final String name;
  FoodSearchInitialEvent({required this.id, required this.name});
}

final class FoodSearchFindResultEvent extends FoodSearchEvent {
  final String searchQuery;
  FoodSearchFindResultEvent({required this.searchQuery});
}

final class FoodSearchModalResponseEvent extends FoodSearchEvent {
  final String id;
  final String collection;
  final FoodInfoModalResponseModel response;
  FoodSearchModalResponseEvent({required this.id, required this.collection, required this.response});
}

final class FoodSearchVariationModalResponseEvent extends FoodSearchEvent {
  final String id;
  final FoodVariationModalResponseDataModel data;
  FoodSearchVariationModalResponseEvent({required this.id, required this.data});
}

final class FoodSearchAddCartEvent extends FoodSearchEvent {
  final String id;
  FoodSearchAddCartEvent({required this.id});
}

final class FoodSearchRepeatFoodOrderResponseEvent extends FoodSearchEvent {
  final String id;
  final RepeatQuantityModalResponseModel data;
  FoodSearchRepeatFoodOrderResponseEvent({required this.id, required this.data});
}

final class FoodSearchFoodQuantityDecreaseEvent extends FoodSearchEvent {
  final String id;
  FoodSearchFoodQuantityDecreaseEvent({required this.id});
}

final class FoodSearchFoodVariationModalRepeatResponseEvent extends FoodSearchEvent {
  final String id;
  FoodVariationModalResponseDataModel data;
  FoodSearchFoodVariationModalRepeatResponseEvent({required this.id, required this.data});
}

final class FoodSearchFoodQuantityIncreaseEvent extends FoodSearchEvent {
  final String id;
  FoodSearchFoodQuantityIncreaseEvent({required this.id});
}

final class FoodSearchExecuteEvent extends FoodSearchEvent {
  final String query;
  FoodSearchExecuteEvent({required this.query});
}
