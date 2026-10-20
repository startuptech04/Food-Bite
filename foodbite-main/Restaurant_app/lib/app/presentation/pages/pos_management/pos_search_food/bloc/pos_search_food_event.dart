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

part of 'pos_search_food_bloc.dart';

sealed class PosSearchFoodEvent {}

final class PosSearchFoodInitialEvent extends PosSearchFoodEvent {}

final class PosSearchFoodFindResultEvent extends PosSearchFoodEvent {
  final String searchQuery;
  PosSearchFoodFindResultEvent({required this.searchQuery});
}

final class PosSearchModalResponseEvent extends PosSearchFoodEvent {
  final String id;
  final String collection;
  final PosFoodInfoModalResponseModel response;
  PosSearchModalResponseEvent({required this.id, required this.collection, required this.response});
}

final class PosSearchVariationModalResponseEvent extends PosSearchFoodEvent {
  final String id;
  final PosFoodVariationModalResponseDataModel data;
  PosSearchVariationModalResponseEvent({required this.id, required this.data});
}

final class PosSearchAddCartEvent extends PosSearchFoodEvent {
  final String id;
  PosSearchAddCartEvent({required this.id});
}

final class PosSearchRepeatFoodOrderResponseEvent extends PosSearchFoodEvent {
  final String id;
  final PosRepeatQuantityModalResponseModel data;
  PosSearchRepeatFoodOrderResponseEvent({required this.id, required this.data});
}

final class PosSearchFoodQuantityDecreaseEvent extends PosSearchFoodEvent {
  final String id;
  PosSearchFoodQuantityDecreaseEvent({required this.id});
}

final class PosSearchFoodVariationModalRepeatResponseEvent extends PosSearchFoodEvent {
  final String id;
  PosFoodVariationModalResponseDataModel data;
  PosSearchFoodVariationModalRepeatResponseEvent({required this.id, required this.data});
}

final class PosSearchFoodQuantityIncreaseEvent extends PosSearchFoodEvent {
  final String id;
  PosSearchFoodQuantityIncreaseEvent({required this.id});
}

final class PosSearchFoodExecuteQueryEvent extends PosSearchFoodEvent {
  final String query;
  PosSearchFoodExecuteQueryEvent({required this.query});
}
