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

enum FoodCampaignStatus { loading, success, failure, loadMore, loaderStarted, loaderEnded, loaderEndedWithError }

extension FoodCampaignStatusX on FoodCampaignStatus {
  bool get isLoading => this == FoodCampaignStatus.loading;
  bool get isSuccess => this == FoodCampaignStatus.success;
  bool get isFailure => this == FoodCampaignStatus.failure;
  bool get isLoadMore => this == FoodCampaignStatus.loadMore;
  bool get isLoaderStarted => this == FoodCampaignStatus.loaderStarted;
  bool get isLoaderEnded => this == FoodCampaignStatus.loaderEnded;
  bool get isLoaderEndedWithError => this == FoodCampaignStatus.loaderEndedWithError;
}

final class FoodCampaignState {
  final FoodCampaignListModel campaigns;
  final int pageSize;
  final int currentPage;
  final String vendorId;
  final String action;
  final FoodCampaignStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodCampaignState({
    required this.campaigns,
    required this.pageSize,
    required this.vendorId,
    this.currentPage = 0,
    this.action = '',
    this.status = FoodCampaignStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FoodCampaignState copyWith({FoodCampaignListModel? campaigns, int? pageSize, int? currentPage, String? vendorId, String? action, FoodCampaignStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return FoodCampaignState(
      campaigns: campaigns ?? this.campaigns,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      vendorId: vendorId ?? this.vendorId,
      action: action ?? this.action,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
