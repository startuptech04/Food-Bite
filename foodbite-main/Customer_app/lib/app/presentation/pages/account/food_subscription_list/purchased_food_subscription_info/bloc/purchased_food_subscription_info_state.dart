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

part of 'purchased_food_subscription_info_bloc.dart';

enum PurchasedFoodSubscriptionInfoStatus { loading, failure, success, repaySubscriptionRequested, repaySubscriptionSuccess, repaySubscriptionFailed, cancelRequested, cancelSuccess, cancelFailed }

extension PurchasedFoodSubscriptionInfoStatusX on PurchasedFoodSubscriptionInfoStatus {
  bool get isLoading => this == PurchasedFoodSubscriptionInfoStatus.loading;
  bool get isFailure => this == PurchasedFoodSubscriptionInfoStatus.failure;
  bool get isSuccess => this == PurchasedFoodSubscriptionInfoStatus.success;
  bool get isRepaySubscriptionRequested => this == PurchasedFoodSubscriptionInfoStatus.repaySubscriptionRequested;
  bool get isRepaySubscriptionSuccess => this == PurchasedFoodSubscriptionInfoStatus.repaySubscriptionSuccess;
  bool get isRepaySubscriptionFailed => this == PurchasedFoodSubscriptionInfoStatus.repaySubscriptionFailed;
  bool get isCancelRequested => this == PurchasedFoodSubscriptionInfoStatus.cancelRequested;
  bool get isCancelSuccess => this == PurchasedFoodSubscriptionInfoStatus.cancelSuccess;
  bool get isCancelFailed => this == PurchasedFoodSubscriptionInfoStatus.cancelFailed;
}

final class PurchasedFoodSubscriptionInfoState {
  final String purchaseId;
  final String newPaymentId;
  final String paymentName;
  final String paymentImageURL;
  final PurchasedTiffinSubscriptionPackageInfoResponseModel info;
  final bool isPendingPaymentTimeOver;
  final String? paymentURL;
  final String? statusName;
  final bool? callRestaurant;
  final PurchasedFoodSubscriptionInfoStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PurchasedFoodSubscriptionInfoState({
    this.purchaseId = '',
    this.newPaymentId = '',
    this.paymentName = '',
    this.paymentImageURL = '',
    required this.info,
    this.isPendingPaymentTimeOver = true,
    this.paymentURL = '',
    this.statusName = '',
    this.callRestaurant = false,
    this.status = PurchasedFoodSubscriptionInfoStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  PurchasedFoodSubscriptionInfoState copyWith({
    String? purchaseId,
    String? newPaymentId,
    String? paymentName,
    String? paymentImageURL,
    PurchasedTiffinSubscriptionPackageInfoResponseModel? info,
    bool? isPendingPaymentTimeOver,
    String? paymentURL,
    String? statusName,
    bool? callRestaurant,
    PurchasedFoodSubscriptionInfoStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return PurchasedFoodSubscriptionInfoState(
      purchaseId: purchaseId ?? this.purchaseId,
      newPaymentId: newPaymentId ?? this.newPaymentId,
      paymentName: paymentName ?? this.paymentName,
      paymentImageURL: paymentImageURL ?? this.paymentImageURL,
      info: info ?? this.info,
      isPendingPaymentTimeOver: isPendingPaymentTimeOver ?? this.isPendingPaymentTimeOver,
      paymentURL: paymentURL ?? this.paymentURL,
      statusName: statusName ?? this.statusName,
      callRestaurant: callRestaurant ?? this.callRestaurant,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
