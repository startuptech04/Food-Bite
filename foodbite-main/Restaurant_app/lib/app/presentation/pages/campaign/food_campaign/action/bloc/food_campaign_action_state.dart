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

enum FoodCampaignActionStatus { loading, success, failure, loaderStarted, loaderEnded, loaderEndedWithError }

extension FoodCampaignActionStatusX on FoodCampaignActionStatus {
  bool get isLoading => this == FoodCampaignActionStatus.loading;
  bool get isSuccess => this == FoodCampaignActionStatus.success;
  bool get isFailure => this == FoodCampaignActionStatus.failure;
  bool get isLoaderStarted => this == FoodCampaignActionStatus.loaderStarted;
  bool get isLoaderEnded => this == FoodCampaignActionStatus.loaderEnded;
  bool get isLoaderEndedWithError => this == FoodCampaignActionStatus.loaderEndedWithError;
}

final class FoodCampaignActionState {
  final FoodCampaignDetailsMyFoodListModel campaigns;
  final String id;
  final String title;
  final List<String> savedFoods;
  final String vendorId;
  final String action;
  final FoodCampaignActionStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodCampaignActionState({
    required this.campaigns,
    required this.id,
    required this.title,
    required this.savedFoods,
    required this.vendorId,
    this.action = '',
    this.status = FoodCampaignActionStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FoodCampaignActionState copyWith({
    FoodCampaignDetailsMyFoodListModel? campaigns,
    String? id,
    String? title,
    List<String>? savedFoods,
    String? vendorId,
    String? action,
    FoodCampaignActionStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return FoodCampaignActionState(
      campaigns: campaigns ?? this.campaigns,
      id: id ?? this.id,
      title: title ?? this.title,
      savedFoods: savedFoods ?? this.savedFoods,
      vendorId: vendorId ?? this.vendorId,
      action: action ?? this.action,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
