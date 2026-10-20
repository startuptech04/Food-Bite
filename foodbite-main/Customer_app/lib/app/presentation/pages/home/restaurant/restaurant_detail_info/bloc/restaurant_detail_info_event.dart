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

part of 'restaurant_detail_info_bloc.dart';

sealed class RestaurantDetailInfoEvent {}

final class RestaurantDetailInfoInitialEvent extends RestaurantDetailInfoEvent {
  final String id;
  final String name;
  final String slug;
  final String campaignId;
  RestaurantDetailInfoInitialEvent({required this.id, required this.name, required this.slug, required this.campaignId});
}

final class RestaurantDetailInfoFavouriteEvent extends RestaurantDetailInfoEvent {}

final class RestaurantDetailInfoShareEvent extends RestaurantDetailInfoEvent {}

final class RestaurantDetailInfoDirectionEvent extends RestaurantDetailInfoEvent {}

final class RestaurantCallNumberEvent extends RestaurantDetailInfoEvent {}

final class RestaurantShowMoreSlotEvent extends RestaurantDetailInfoEvent {
  final int slotIndex;
  RestaurantShowMoreSlotEvent({required this.slotIndex});
}
