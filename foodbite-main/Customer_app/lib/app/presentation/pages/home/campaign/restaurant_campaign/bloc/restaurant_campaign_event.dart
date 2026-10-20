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

part of 'restaurant_campaign_bloc.dart';

sealed class RestaurantCampaignEvent {}

final class RestaurantCampaignInitialEvent extends RestaurantCampaignEvent {
  final String id;
  RestaurantCampaignInitialEvent({required this.id});
}

final class RestaurantCampaignFavouriteEvent extends RestaurantCampaignEvent {
  final String id;
  final bool isFavourite;
  RestaurantCampaignFavouriteEvent({required this.id, required this.isFavourite});
}

final class RestaurantCampaignHideEvent extends RestaurantCampaignEvent {
  final String id;
  RestaurantCampaignHideEvent({required this.id});
}

final class RestaurantCampaignRemoveRestaurantEvent extends RestaurantCampaignEvent {
  final String id;
  RestaurantCampaignRemoveRestaurantEvent({required this.id});
}

final class RestaurantCampaignUndoHideActionEvent extends RestaurantCampaignEvent {
  final String id;
  RestaurantCampaignUndoHideActionEvent({required this.id});
}

final class RestaurantCampaignNavigateEvent extends RestaurantCampaignEvent {}
