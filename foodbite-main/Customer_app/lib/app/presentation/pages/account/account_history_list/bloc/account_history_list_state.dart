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

part of 'account_history_list_bloc.dart';

enum AccountHistoryListStatus { loading, success, failure, empty, unAuthorized }

extension AccountHistoryListStatusX on AccountHistoryListStatus {
  bool get isLoading => this == AccountHistoryListStatus.loading;
  bool get isSuccess => this == AccountHistoryListStatus.success;
  bool get isFailure => this == AccountHistoryListStatus.failure;
  bool get isEmpty => this == AccountHistoryListStatus.empty;
  bool get isUnAuthorized => this == AccountHistoryListStatus.unAuthorized;
}

final class AccountHistoryListState {
  final MyOrderListResponseModel orderList;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final AccountHistoryListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountHistoryListState({
    required this.orderList,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = AccountHistoryListStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  AccountHistoryListState copyWith({MyOrderListResponseModel? orderList, int? pageSize, int? currentPage, bool? loadMore, AccountHistoryListStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return AccountHistoryListState(
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
