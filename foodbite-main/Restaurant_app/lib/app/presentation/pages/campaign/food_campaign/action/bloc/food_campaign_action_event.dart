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

part of 'food_campaign_action_bloc.dart';

sealed class FoodCampaignActionEvent {}

final class FoodCampaignActionInitialEvent extends FoodCampaignActionEvent {
  final String id;
  final String title;
  final List<String> savedFoods;
  FoodCampaignActionInitialEvent({required this.id, required this.title, required this.savedFoods});
}

final class FoodCampaignActionJoinEvent extends FoodCampaignActionEvent {
  final String id;
  FoodCampaignActionJoinEvent({required this.id});
}

final class FoodCampaignActionLeaveEvent extends FoodCampaignActionEvent {
  final int index;
  final String id;
  FoodCampaignActionLeaveEvent({required this.index, required this.id});
}
