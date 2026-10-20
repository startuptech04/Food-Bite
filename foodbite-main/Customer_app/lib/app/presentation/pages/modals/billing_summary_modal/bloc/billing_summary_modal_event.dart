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

part of 'billing_summary_modal_bloc.dart';

sealed class BillingSummaryModalEvent {}

final class BillingSummaryModalInitialEvent extends BillingSummaryModalEvent {
  final String orderTo;
  final double realTotal;
  final double itemTotal;
  final double itemDiscount;
  final double couponDiscount;
  final String couponCode;
  final double walletAmount;
  final double serviceCharge;
  final String serviceChargeName;
  final double foodServiceCharge;
  final String foodServiceChargeName;
  final String deliveryGratitude;
  final double deliveryTip;
  final double extraCharge;
  final double deliveryCharge;
  final double packagingCharges;
  final double packagingChargesTax;
  final double grandTotal;
  BillingSummaryModalInitialEvent({
    required this.orderTo,
    required this.realTotal,
    required this.itemTotal,
    required this.itemDiscount,
    required this.couponDiscount,
    required this.couponCode,
    required this.walletAmount,
    required this.serviceCharge,
    required this.serviceChargeName,
    required this.foodServiceCharge,
    required this.foodServiceChargeName,
    required this.deliveryGratitude,
    required this.deliveryTip,
    required this.extraCharge,
    required this.deliveryCharge,
    required this.packagingCharges,
    required this.packagingChargesTax,
    required this.grandTotal,
  });
}

final class BillingSummaryModalDeliveryGratitudeEvent extends BillingSummaryModalEvent {
  final double tip;
  BillingSummaryModalDeliveryGratitudeEvent({required this.tip});
}
