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

part of 'food_subscription_transaction_list_bloc.dart';

enum FoodSubscriptionTransactionListStatus { loading, success, failure, empty, unAuthorized }

extension FoodSubscriptionTransactionListStatusX on FoodSubscriptionTransactionListStatus {
  bool get isLoading => this == FoodSubscriptionTransactionListStatus.loading;
  bool get isSuccess => this == FoodSubscriptionTransactionListStatus.success;
  bool get isFailure => this == FoodSubscriptionTransactionListStatus.failure;
  bool get isEmpty => this == FoodSubscriptionTransactionListStatus.empty;
  bool get isUnAuthorized => this == FoodSubscriptionTransactionListStatus.unAuthorized;
}

final class FoodSubscriptionTransactionListState {
  final UserFoodSubscriptionTransactionResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final FoodSubscriptionTransactionListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FoodSubscriptionTransactionListState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = FoodSubscriptionTransactionListStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  FoodSubscriptionTransactionListState copyWith({
    UserFoodSubscriptionTransactionResponseModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    FoodSubscriptionTransactionListStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return FoodSubscriptionTransactionListState(
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
