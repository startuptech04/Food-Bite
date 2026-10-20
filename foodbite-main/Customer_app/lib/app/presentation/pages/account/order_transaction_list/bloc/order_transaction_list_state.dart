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

part of 'order_transaction_list_bloc.dart';

enum OrderTransactionListStatus { loading, success, failure, empty, unAuthorized }

extension OrderTransactionListStatusX on OrderTransactionListStatus {
  bool get isLoading => this == OrderTransactionListStatus.loading;
  bool get isSuccess => this == OrderTransactionListStatus.success;
  bool get isFailure => this == OrderTransactionListStatus.failure;
  bool get isEmpty => this == OrderTransactionListStatus.empty;
  bool get isUnAuthorized => this == OrderTransactionListStatus.unAuthorized;
}

final class OrderTransactionListState {
  final UserOrderTransactionResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final OrderTransactionListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const OrderTransactionListState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = OrderTransactionListStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  OrderTransactionListState copyWith({UserOrderTransactionResponseModel? model, int? pageSize, int? currentPage, bool? loadMore, OrderTransactionListStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return OrderTransactionListState(
      model: model ?? this.model,
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
