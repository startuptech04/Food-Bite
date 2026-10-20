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

part of 'order_coupon_list_bloc.dart';

enum OrderCouponListStatus { loading, success, failure, empty, loadingHideStart, loadingHideSuccess, loadingHideFailed, loadingDeleteStart, loadingDeleteSuccess, loadingDeleteFailed }

extension OrderCouponListStatusX on OrderCouponListStatus {
  bool get isLoading => this == OrderCouponListStatus.loading;
  bool get isSuccess => this == OrderCouponListStatus.success;
  bool get isFailure => this == OrderCouponListStatus.failure;
  bool get isEmpty => this == OrderCouponListStatus.empty;
  bool get isLoadingHideStart => this == OrderCouponListStatus.loadingHideStart;
  bool get isLoadingHideSuccess => this == OrderCouponListStatus.loadingHideSuccess;
  bool get isLoadingHideFailed => this == OrderCouponListStatus.loadingHideFailed;
  bool get isLoadingDeleteStart => this == OrderCouponListStatus.loadingDeleteStart;
  bool get isLoadingDeleteSuccess => this == OrderCouponListStatus.loadingDeleteSuccess;
  bool get isLoadingDeleteFailed => this == OrderCouponListStatus.loadingDeleteFailed;
}

final class OrderCouponListState {
  final String appLocale;
  final OrderCouponListModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final OrderCouponListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderCouponListState({
    this.appLocale = '',
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = OrderCouponListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  OrderCouponListState copyWith({String? appLocale, OrderCouponListModel? model, int? pageSize, int? currentPage, bool? loadMore, OrderCouponListStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OrderCouponListState(
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
