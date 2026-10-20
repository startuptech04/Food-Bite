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

part of 'favourite_orders_bloc.dart';

enum FavouriteOrdersStatus { loading, success, failure, empty, unAuthorized }

extension FavouriteOrdersStatusX on FavouriteOrdersStatus {
  bool get isLoading => this == FavouriteOrdersStatus.loading;
  bool get isSuccess => this == FavouriteOrdersStatus.success;
  bool get isFailure => this == FavouriteOrdersStatus.failure;
  bool get isEmpty => this == FavouriteOrdersStatus.empty;
  bool get isUnAuthorized => this == FavouriteOrdersStatus.unAuthorized;
}

final class FavouriteOrdersState {
  final MyFavouriteOrderListResponseModel orderList;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final FavouriteOrdersStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FavouriteOrdersState({
    required this.orderList,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = FavouriteOrdersStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  FavouriteOrdersState copyWith({MyFavouriteOrderListResponseModel? orderList, int? pageSize, int? currentPage, bool? loadMore, FavouriteOrdersStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return FavouriteOrdersState(
      orderList: orderList ?? this.orderList,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
