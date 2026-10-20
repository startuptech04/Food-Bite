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

part of 'tiffin_subscription_purchase_history_detail_bloc.dart';

enum TiffinSubscriptionPurchaseHistoryDetailStatus { loading, success, failure, callCustomer, callSuccess, customError }

extension TiffinSubscriptionPurchaseHistoryDetailStatusX on TiffinSubscriptionPurchaseHistoryDetailStatus {
  bool get isLoading => this == TiffinSubscriptionPurchaseHistoryDetailStatus.loading;
  bool get isSuccess => this == TiffinSubscriptionPurchaseHistoryDetailStatus.success;
  bool get isFailure => this == TiffinSubscriptionPurchaseHistoryDetailStatus.failure;
  bool get isCallCustomer => this == TiffinSubscriptionPurchaseHistoryDetailStatus.callCustomer;
  bool get isCallSucces => this == TiffinSubscriptionPurchaseHistoryDetailStatus.callSuccess;
  bool get isCustomError => this == TiffinSubscriptionPurchaseHistoryDetailStatus.customError;
}

final class TiffinSubscriptionPurchaseHistoryDetailState {
  final String purchaseId;
  final TiffinSubscriptionPurchaseHistoryDetailResponseModel model;
  final TiffinSubscriptionPurchaseHistoryDetailStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TiffinSubscriptionPurchaseHistoryDetailState({
    this.purchaseId = '',
    required this.model,
    this.status = TiffinSubscriptionPurchaseHistoryDetailStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  TiffinSubscriptionPurchaseHistoryDetailState copyWith({
    String? purchaseId,
    TiffinSubscriptionPurchaseHistoryDetailResponseModel? model,
    TiffinSubscriptionPurchaseHistoryDetailStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return TiffinSubscriptionPurchaseHistoryDetailState(
      purchaseId: purchaseId ?? this.purchaseId,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
