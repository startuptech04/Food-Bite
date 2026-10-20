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

sealed class TiffinSubscriptionPackageHelpModalEvent {}

final class TiffinSubscriptionPackageHelpModalInitialEvent extends TiffinSubscriptionPackageHelpModalEvent {
  final String purchaseId;
  final String purchaseStatus;
  final bool refundRequestEnable;
  final String subscriptionPackage;
  final String restaurant;
  final String payment;
  final List<String> requestedOffDates;
  final List<String> offDays;
  final int totalOrders;
  TiffinSubscriptionPackageHelpModalInitialEvent({
    required this.purchaseId,
    required this.purchaseStatus,
    required this.subscriptionPackage,
    required this.restaurant,
    required this.payment,
    required this.refundRequestEnable,
    required this.requestedOffDates,
    required this.offDays,
    required this.totalOrders,
  });
}

final class TiffinSubscriptionPackageHelpModalRefundRequestEvent extends TiffinSubscriptionPackageHelpModalEvent {
  final String reasonId;
  TiffinSubscriptionPackageHelpModalRefundRequestEvent({required this.reasonId});
}

final class TiffinSubscriptionPackageHelpModalSummaryEvent extends TiffinSubscriptionPackageHelpModalEvent {}

final class TiffinSubscriptionPackageHelpModalInvoiceEvent extends TiffinSubscriptionPackageHelpModalEvent {}
