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

enum RestaurantCampaignStatus { loading, success, failure, loadMore, loaderStarted, loaderEnded, loaderEndedWithError }

extension RestaurantCampaignStatusX on RestaurantCampaignStatus {
  bool get isLoading => this == RestaurantCampaignStatus.loading;
  bool get isSuccess => this == RestaurantCampaignStatus.success;
  bool get isFailure => this == RestaurantCampaignStatus.failure;
  bool get isLoadMore => this == RestaurantCampaignStatus.loadMore;
  bool get isLoaderStarted => this == RestaurantCampaignStatus.loaderStarted;
  bool get isLoaderEnded => this == RestaurantCampaignStatus.loaderEnded;
  bool get isLoaderEndedWithError => this == RestaurantCampaignStatus.loaderEndedWithError;
}

final class RestaurantCampaignState {
  final RestaurantCampaignListModel campaigns;
  final int pageSize;
  final int currentPage;
  final String vendorId;
  final String action;
  final RestaurantCampaignStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const RestaurantCampaignState({
    required this.campaigns,
    required this.pageSize,
    required this.vendorId,
    this.currentPage = 0,
    this.action = '',
    this.status = RestaurantCampaignStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  RestaurantCampaignState copyWith({
    RestaurantCampaignListModel? campaigns,
    int? pageSize,
    int? currentPage,
    String? vendorId,
    String? action,
    RestaurantCampaignStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return RestaurantCampaignState(
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
