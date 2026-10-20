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

part of 'account_review_activity_bloc.dart';

enum AccountReviewActivityStatus { loading, success, failure, empty }

extension AccountReviewActivityStatusX on AccountReviewActivityStatus {
  bool get isLoading => this == AccountReviewActivityStatus.loading;
  bool get isSuccess => this == AccountReviewActivityStatus.success;
  bool get isFailure => this == AccountReviewActivityStatus.failure;
  bool get isEmpty => this == AccountReviewActivityStatus.empty;
}

final class AccountReviewActivityState {
  final MyReviewListActivityModel model;
  final bool isFoodReviewOpen;
  final bool isRestaurantReviewOpen;
  final bool isDriverReviewOpen;
  final AccountReviewActivityStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountReviewActivityState({
    required this.model,
    this.isFoodReviewOpen = true,
    this.isRestaurantReviewOpen = true,
    this.isDriverReviewOpen = true,
    this.status = AccountReviewActivityStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  AccountReviewActivityState copyWith({
    MyReviewListActivityModel? model,
    bool? isFoodReviewOpen,
    bool? isRestaurantReviewOpen,
    bool? isDriverReviewOpen,
    AccountReviewActivityStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return AccountReviewActivityState(
      model: model ?? this.model,
      isFoodReviewOpen: isFoodReviewOpen ?? this.isFoodReviewOpen,
      isRestaurantReviewOpen: isRestaurantReviewOpen ?? this.isRestaurantReviewOpen,
      isDriverReviewOpen: isDriverReviewOpen ?? this.isDriverReviewOpen,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
