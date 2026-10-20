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

part of 'tiffin_subscription_package_help_modal_bloc.dart';

enum TiffinSubscriptionPackageHelpModalStatus {
  initial,
  refundRequestStarted,
  refundRequestFailed,
  refundRequestSuccess,
  summaryDownloadStarted,
  summaryDownloadFailed,
  summaryDownloadSuccess,
  invoiceDownloadStarted,
  invoiceDownloadFailed,
  invoiceDownloadSuccess,
  customError,
}

extension TiffinSubscriptionPackageHelpModalStatusX on TiffinSubscriptionPackageHelpModalStatus {
  bool get isInitial => this == TiffinSubscriptionPackageHelpModalStatus.initial;
  bool get isRefundRequestStarted => this == TiffinSubscriptionPackageHelpModalStatus.refundRequestStarted;
  bool get isRefundRequestFailed => this == TiffinSubscriptionPackageHelpModalStatus.refundRequestFailed;
  bool get isRefundRequestSuccess => this == TiffinSubscriptionPackageHelpModalStatus.refundRequestSuccess;
  bool get isSummaryDownloadStarted => this == TiffinSubscriptionPackageHelpModalStatus.summaryDownloadStarted;
  bool get isSummaryDownloadFailed => this == TiffinSubscriptionPackageHelpModalStatus.summaryDownloadFailed;
  bool get isSummaryDownloadSuccess => this == TiffinSubscriptionPackageHelpModalStatus.summaryDownloadSuccess;
  bool get isInvoiceDownloadStarted => this == TiffinSubscriptionPackageHelpModalStatus.invoiceDownloadStarted;
  bool get isInvoiceDownloadFailed => this == TiffinSubscriptionPackageHelpModalStatus.invoiceDownloadFailed;
  bool get isInvoiceDownloadSuccess => this == TiffinSubscriptionPackageHelpModalStatus.invoiceDownloadSuccess;
  bool get isCustomError => this == TiffinSubscriptionPackageHelpModalStatus.customError;
}

final class TiffinSubscriptionPackageHelpModalState {
  final String purchaseId;
  final String purchaseStatus;
  final String subscriptionPackage;
  final String restaurant;
  final String payment;
  final List<String> requestedOffDates;
  final List<String> offDays;
  final int totalOrders;
  final bool refundRequestEnable;
  final String downloadPath;
  final TiffinSubscriptionPackageHelpModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const TiffinSubscriptionPackageHelpModalState({
    this.purchaseId = '',
    this.purchaseStatus = '',
    this.subscriptionPackage = '',
    this.restaurant = '',
    this.payment = '',
    this.requestedOffDates = const [],
    this.offDays = const [],
    this.totalOrders = 0,
    this.refundRequestEnable = false,
    this.downloadPath = '',
    this.status = TiffinSubscriptionPackageHelpModalStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  TiffinSubscriptionPackageHelpModalState copyWith({
    String? purchaseId,
    String? purchaseStatus,
    String? subscriptionPackage,
    String? restaurant,
    String? payment,
    List<String>? requestedOffDates,
    List<String>? offDays,
    int? totalOrders,
    bool? refundRequestEnable,
    String? downloadPath,
    TiffinSubscriptionPackageHelpModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return TiffinSubscriptionPackageHelpModalState(
      purchaseId: purchaseId ?? this.purchaseId,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      subscriptionPackage: subscriptionPackage ?? this.subscriptionPackage,
      restaurant: restaurant ?? this.restaurant,
      payment: payment ?? this.payment,
      requestedOffDates: requestedOffDates ?? this.requestedOffDates,
      offDays: offDays ?? this.offDays,
      totalOrders: totalOrders ?? this.totalOrders,
      refundRequestEnable: refundRequestEnable ?? this.refundRequestEnable,
      downloadPath: downloadPath ?? this.downloadPath,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
