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

part of 'dining_coupon_list_bloc.dart';

enum DiningCouponListStatus { loading, success, failure, empty, loadingHideStart, loadingHideSuccess, loadingHideFailed, loadingDeleteStart, loadingDeleteSuccess, loadingDeleteFailed }

extension DiningCouponListStatusX on DiningCouponListStatus {
  bool get isLoading => this == DiningCouponListStatus.loading;
  bool get isSuccess => this == DiningCouponListStatus.success;
  bool get isFailure => this == DiningCouponListStatus.failure;
  bool get isEmpty => this == DiningCouponListStatus.empty;
  bool get isLoadingHideStart => this == DiningCouponListStatus.loadingHideStart;
  bool get isLoadingHideSuccess => this == DiningCouponListStatus.loadingHideSuccess;
  bool get isLoadingHideFailed => this == DiningCouponListStatus.loadingHideFailed;
  bool get isLoadingDeleteStart => this == DiningCouponListStatus.loadingDeleteStart;
  bool get isLoadingDeleteSuccess => this == DiningCouponListStatus.loadingDeleteSuccess;
  bool get isLoadingDeleteFailed => this == DiningCouponListStatus.loadingDeleteFailed;
}

final class DiningCouponListState {
  final String appLocale;
  final DiningCouponListResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final DiningCouponListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningCouponListState({
    this.appLocale = '',
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = DiningCouponListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DiningCouponListState copyWith({
    String? appLocale,
    DiningCouponListResponseModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    DiningCouponListStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return DiningCouponListState(
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
