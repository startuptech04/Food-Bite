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

part of 'account_favourite_order_list_bloc.dart';

enum AccountFavouriteOrderListStatus { loading, success, failure, empty, unAuthorized }

extension AccountFavouriteOrderListStatusX on AccountFavouriteOrderListStatus {
  bool get isLoading => this == AccountFavouriteOrderListStatus.loading;
  bool get isSuccess => this == AccountFavouriteOrderListStatus.success;
  bool get isFailure => this == AccountFavouriteOrderListStatus.failure;
  bool get isEmpty => this == AccountFavouriteOrderListStatus.empty;
  bool get isUnAuthorized => this == AccountFavouriteOrderListStatus.unAuthorized;
}

final class AccountFavouriteOrderListState {
  final MyFavouriteOrderListResponseModel orderList;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final AccountFavouriteOrderListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountFavouriteOrderListState({
    required this.orderList,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = AccountFavouriteOrderListStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  AccountFavouriteOrderListState copyWith({
    MyFavouriteOrderListResponseModel? orderList,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    AccountFavouriteOrderListStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return AccountFavouriteOrderListState(
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
