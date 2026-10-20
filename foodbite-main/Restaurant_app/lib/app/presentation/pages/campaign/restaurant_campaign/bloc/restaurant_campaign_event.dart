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

final class RestaurantCampaignInitialEvent extends RestaurantCampaignEvent {}

final class RestaurantCampaignLeaveEvent extends RestaurantCampaignEvent {
  final String campaignId;
  RestaurantCampaignLeaveEvent({required this.campaignId});
}

final class RestaurantCampaignJoinEvent extends RestaurantCampaignEvent {
  final String campaignId;
  RestaurantCampaignJoinEvent({required this.campaignId});
}

final class RestaurantCampaignLoadMoreEvent extends RestaurantCampaignEvent {}
