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

part of 'food_campaign_bloc.dart';

sealed class FoodCampaignEvent {}

final class FoodCampaignInitialEvent extends FoodCampaignEvent {
  final String id;
  FoodCampaignInitialEvent({required this.id});
}

final class FoodCampaignFavouriteEvent extends FoodCampaignEvent {
  final String id;
  final bool isFavourite;
  FoodCampaignFavouriteEvent({required this.id, required this.isFavourite});
}

final class FoodCampaignVariationModalResponseEvent extends FoodCampaignEvent {
  final String id;
  final FoodVariationModalResponseDataModel data;
  FoodCampaignVariationModalResponseEvent({required this.id, required this.data});
}

final class FoodCampaignFoodQuantityDecreaseEvent extends FoodCampaignEvent {
  final String id;
  FoodCampaignFoodQuantityDecreaseEvent({required this.id});
}

final class FoodCampaignFoodQuantityIncreaseEvent extends FoodCampaignEvent {
  final String id;
  FoodCampaignFoodQuantityIncreaseEvent({required this.id});
}

final class FoodCampaignAddCartEvent extends FoodCampaignEvent {
  final String id;
  FoodCampaignAddCartEvent({required this.id});
}

final class FoodCampaignRepeatFoodOrderResponseEvent extends FoodCampaignEvent {
  final String id;
  final RepeatQuantityModalResponseModel data;
  FoodCampaignRepeatFoodOrderResponseEvent({required this.id, required this.data});
}

final class FoodCampaignFoodVariationModalRepeatResponseEvent extends FoodCampaignEvent {
  final String id;
  final FoodVariationModalResponseDataModel data;
  FoodCampaignFoodVariationModalRepeatResponseEvent({required this.id, required this.data});
}

final class FoodCampaignFoodModalResponseEvent extends FoodCampaignEvent {
  final String id;
  final FoodInfoModalResponseModel response;
  FoodCampaignFoodModalResponseEvent({required this.id, required this.response});
}
