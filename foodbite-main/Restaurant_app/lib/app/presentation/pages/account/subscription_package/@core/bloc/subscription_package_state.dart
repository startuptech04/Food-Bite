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

part of 'subscription_package_bloc.dart';

enum SubscriptionPackageStatus { loading, success, customError, failure, fetchingPaymentLink, paymentLinkFetched }

extension SubscriptionPackageStatusX on SubscriptionPackageStatus {
  bool get isLoading => this == SubscriptionPackageStatus.loading;
  bool get isSuccess => this == SubscriptionPackageStatus.success;
  bool get isCustomError => this == SubscriptionPackageStatus.customError;
  bool get isFailure => this == SubscriptionPackageStatus.failure;
  bool get isFetchingPaymentLink => this == SubscriptionPackageStatus.fetchingPaymentLink;
  bool get isPaymentLinkFetched => this == SubscriptionPackageStatus.paymentLinkFetched;
}

final class SubscriptionPackageState {
  final SubscriptionPackageInfoModel model;
  final String payment;
  final String paymentName;
  final String paymentImageURL;
  final String paymentLinkId;
  final SubscriptionPackageStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SubscriptionPackageState({
    required this.model,
    this.payment = '',
    this.paymentName = '',
    this.paymentImageURL = '',
    this.paymentLinkId = '',
    this.status = SubscriptionPackageStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  SubscriptionPackageState copyWith({
    SubscriptionPackageInfoModel? model,
    String? payment,
    String? paymentName,
    String? paymentImageURL,
    String? paymentLinkId,
    SubscriptionPackageStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return SubscriptionPackageState(
      model: model ?? this.model,
      payment: payment ?? this.payment,
      paymentName: paymentName ?? this.paymentName,
      paymentImageURL: paymentImageURL ?? this.paymentImageURL,
      paymentLinkId: paymentLinkId ?? this.paymentLinkId,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
