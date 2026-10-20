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

part of 'dining_campaign_bloc.dart';

sealed class DiningCampaignEvent {}

final class DiningCampaignInitialEvent extends DiningCampaignEvent {
  final String id;
  DiningCampaignInitialEvent({required this.id});
}

final class DiningCampaignHideEvent extends DiningCampaignEvent {
  final String id;
  DiningCampaignHideEvent({required this.id});
}

final class DiningCampaignFavouriteEvent extends DiningCampaignEvent {
  final String id;
  final bool isFavourite;
  DiningCampaignFavouriteEvent({required this.id, required this.isFavourite});
}

final class DiningCampaignRemoveRestaurantEvent extends DiningCampaignEvent {
  final String id;
  DiningCampaignRemoveRestaurantEvent({required this.id});
}

final class DiningCampaignUndoHideActionEvent extends DiningCampaignEvent {
  final String id;
  DiningCampaignUndoHideActionEvent({required this.id});
}
