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

part of 'favourite_restaurants_bloc.dart';

sealed class FavouriteRestaurantsEvent {}

final class FavouriteRestaurantsInitialEvent extends FavouriteRestaurantsEvent {}

final class FavouriteRestaurantsLoadMoreEvent extends FavouriteRestaurantsEvent {}

final class FavouriteDeleteRestaurantEvent extends FavouriteRestaurantsEvent {
  final String restaurantId;
  FavouriteDeleteRestaurantEvent({required this.restaurantId});
}

final class FavouriteRestaurantsSilenceEvent extends FavouriteRestaurantsEvent {}
