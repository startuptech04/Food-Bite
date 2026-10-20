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

enum DiningCampaignStatus { loading, success, failure, customError, loadMore, loaderStarted, loaderEnded, loaderEndedWithError }

extension DiningCampaignStatusX on DiningCampaignStatus {
  bool get isLoading => this == DiningCampaignStatus.loading;
  bool get isSuccess => this == DiningCampaignStatus.success;
  bool get isFailure => this == DiningCampaignStatus.failure;
  bool get isCustomError => this == DiningCampaignStatus.customError;
  bool get isLoadMore => this == DiningCampaignStatus.loadMore;
  bool get isLoaderStarted => this == DiningCampaignStatus.loaderStarted;
  bool get isLoaderEnded => this == DiningCampaignStatus.loaderEnded;
  bool get isLoaderEndedWithError => this == DiningCampaignStatus.loaderEndedWithError;
}

final class DiningCampaignState {
  final DiningCampaignListModel campaigns;
  final int pageSize;
  final int currentPage;
  final String vendorId;
  final String action;
  final DiningCampaignStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningCampaignState({
    required this.campaigns,
    required this.pageSize,
    required this.vendorId,
    this.action = '',
    this.currentPage = 0,
    this.status = DiningCampaignStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DiningCampaignState copyWith({DiningCampaignListModel? campaigns, int? pageSize, int? currentPage, String? vendorId, String? action, DiningCampaignStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return DiningCampaignState(
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
