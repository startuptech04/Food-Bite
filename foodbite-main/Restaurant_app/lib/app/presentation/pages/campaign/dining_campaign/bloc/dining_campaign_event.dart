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

final class DiningCampaignInitialEvent extends DiningCampaignEvent {}

final class DiningCampaignLeaveEvent extends DiningCampaignEvent {
  final String campaignId;
  DiningCampaignLeaveEvent({required this.campaignId});
}

final class DiningCampaignJoinEvent extends DiningCampaignEvent {
  final String campaignId;
  DiningCampaignJoinEvent({required this.campaignId});
}

final class DiningCampaignLoadMoreEvent extends DiningCampaignEvent {}
