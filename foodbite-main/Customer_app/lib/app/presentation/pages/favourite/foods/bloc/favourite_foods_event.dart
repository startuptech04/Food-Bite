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

part of 'favourite_foods_bloc.dart';

sealed class FavouriteFoodsEvent {}

final class FavouriteFoodsInitialEvent extends FavouriteFoodsEvent {}

final class FavouriteFoodsLoadMoreEvent extends FavouriteFoodsEvent {}

final class FavouriteFoodsDeleteFoodEvent extends FavouriteFoodsEvent {
  final String foodId;
  FavouriteFoodsDeleteFoodEvent({required this.foodId});
}

final class FavouriteFoodsVariationModalResponseEvent extends FavouriteFoodsEvent {
  final String id;
  final FoodVariationModalResponseDataModel data;
  FavouriteFoodsVariationModalResponseEvent({required this.id, required this.data});
}

final class FavouriteFoodsFoodQuantityDecreaseEvent extends FavouriteFoodsEvent {
  final String id;
  FavouriteFoodsFoodQuantityDecreaseEvent({required this.id});
}

final class FavouriteFoodsFoodQuantityIncreaseEvent extends FavouriteFoodsEvent {
  final String id;
  FavouriteFoodsFoodQuantityIncreaseEvent({required this.id});
}

final class FavouriteFoodsAddCartEvent extends FavouriteFoodsEvent {
  final String id;
  FavouriteFoodsAddCartEvent({required this.id});
}

final class FavouriteFoodsRepeatFoodOrderResponseEvent extends FavouriteFoodsEvent {
  final String id;
  final RepeatQuantityModalResponseModel data;
  FavouriteFoodsRepeatFoodOrderResponseEvent({required this.id, required this.data});
}

final class FavouriteFoodsFoodVariationModalRepeatResponseEvent extends FavouriteFoodsEvent {
  final String id;
  final FoodVariationModalResponseDataModel data;
  FavouriteFoodsFoodVariationModalRepeatResponseEvent({required this.id, required this.data});
}

final class FavouriteFoodsRefreshCartEvent extends FavouriteFoodsEvent {}

final class FavouriteFoodsSilenceEvent extends FavouriteFoodsEvent {}

final class FavouriteFoodModalResponseEvent extends FavouriteFoodsEvent {
  final String id;
  final FoodInfoModalResponseModel response;
  FavouriteFoodModalResponseEvent({required this.id, required this.response});
}
