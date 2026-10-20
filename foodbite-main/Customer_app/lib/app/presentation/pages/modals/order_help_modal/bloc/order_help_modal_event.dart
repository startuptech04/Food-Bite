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

part of 'order_help_modal_bloc.dart';

sealed class OrderHelpModalEvent {}

final class OrderHelpModalInitialEvent extends OrderHelpModalEvent {
  final String orderId;
  final int orderNumber;
  final String orderStatus;
  final String paymentMode;
  final bool refundRequestEnable;
  final String restaurant;
  final String payment;
  final bool subscriptionOrder;
  OrderHelpModalInitialEvent({
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
    required this.paymentMode,
    required this.refundRequestEnable,
    required this.restaurant,
    required this.payment,
    required this.subscriptionOrder,
  });
}

final class OrderHelpModalRefundRequestEvent extends OrderHelpModalEvent {
  final String reasonId;
  OrderHelpModalRefundRequestEvent({required this.reasonId});
}

final class OrderHelpModalOrderSummaryEvent extends OrderHelpModalEvent {}

final class OrderHelpModalOrderInvoiceEvent extends OrderHelpModalEvent {}
