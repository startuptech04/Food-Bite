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

part of 'tiffin_subscription_list_bloc.dart';

enum TiffinSubscriptionListStatus { loading, success, failure, empty, loadingHideStart, loadingHideSuccess, loadingHideFailed, loadingDeleteStart, loadingDeleteSuccess, loadingDeleteFailed }

extension TiffinSubscriptionListStatusX on TiffinSubscriptionListStatus {
  bool get isLoading => this == TiffinSubscriptionListStatus.loading;
  bool get isSuccess => this == TiffinSubscriptionListStatus.success;
  bool get isFailure => this == TiffinSubscriptionListStatus.failure;
  bool get isEmpty => this == TiffinSubscriptionListStatus.empty;
  bool get isLoadingHideStart => this == TiffinSubscriptionListStatus.loadingHideStart;
  bool get isLoadingHideSuccess => this == TiffinSubscriptionListStatus.loadingHideSuccess;
  bool get isLoadingHideFailed => this == TiffinSubscriptionListStatus.loadingHideFailed;
  bool get isLoadingDeleteStart => this == TiffinSubscriptionListStatus.loadingDeleteStart;
  bool get isLoadingDeleteSuccess => this == TiffinSubscriptionListStatus.loadingDeleteSuccess;
  bool get isLoadingDeleteFailed => this == TiffinSubscriptionListStatus.loadingDeleteFailed;
}

final class TiffinSubscriptionListState {
  final String appLocale;
  final TiffinSubscriptionPackageListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final TiffinSubscriptionListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TiffinSubscriptionListState({
    this.appLocale = '',
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = TiffinSubscriptionListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  TiffinSubscriptionListState copyWith({
    String? appLocale,
    TiffinSubscriptionPackageListResponseModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    TiffinSubscriptionListStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return TiffinSubscriptionListState(
      appLocale: appLocale ?? this.appLocale,
      model: model ?? this.model,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
