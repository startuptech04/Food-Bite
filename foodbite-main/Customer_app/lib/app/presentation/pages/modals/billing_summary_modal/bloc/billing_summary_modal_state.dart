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

enum BillingSummaryModalStatus { initial, success, failure }

extension BillingSummaryModalStatusX on BillingSummaryModalStatus {
  bool get isInitial => this == BillingSummaryModalStatus.initial;
  bool get isSuccess => this == BillingSummaryModalStatus.success;
  bool get isFailure => this == BillingSummaryModalStatus.failure;
}

final class BillingSummaryModalState {
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
  final List<GratitudesConfigModel> gratitudeList;
  final double deliveryTip;
  final double extraCharge;
  final double deliveryCharge;
  final double packagingCharges;
  final double packagingChargesTax;
  final double grandTotal;
  final BillingSummaryModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const BillingSummaryModalState({
    this.orderTo = '',
    this.realTotal = 0,
    this.itemTotal = 0,
    this.itemDiscount = 0,
    this.couponDiscount = 0,
    this.couponCode = '',
    this.walletAmount = 0,
    this.serviceCharge = 0,
    this.serviceChargeName = '',
    this.foodServiceCharge = 0,
    this.foodServiceChargeName = '',
    this.gratitudeList = const [],
    this.deliveryTip = 0,
    this.extraCharge = 0,
    this.packagingCharges = 0,
    this.packagingChargesTax = 0,
    this.deliveryCharge = 0,
    this.grandTotal = 0,
    this.status = BillingSummaryModalStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  BillingSummaryModalState copyWith({
    String? orderTo,
    double? realTotal,
    double? itemTotal,
    double? itemDiscount,
    double? couponDiscount,
    String? couponCode,
    double? walletAmount,
    double? serviceCharge,
    String? serviceChargeName,
    double? foodServiceCharge,
    String? foodServiceChargeName,
    List<GratitudesConfigModel>? gratitudeList,
    double? deliveryTip,
    double? extraCharge,
    double? deliveryCharge,
    double? packagingCharges,
    double? packagingChargesTax,
    double? grandTotal,
    BillingSummaryModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return BillingSummaryModalState(
      orderTo: orderTo ?? this.orderTo,
      realTotal: realTotal ?? this.realTotal,
      itemTotal: itemTotal ?? this.itemTotal,
      itemDiscount: itemDiscount ?? this.itemDiscount,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      couponCode: couponCode ?? this.couponCode,
      walletAmount: walletAmount ?? this.walletAmount,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      serviceChargeName: serviceChargeName ?? this.serviceChargeName,
      foodServiceCharge: foodServiceCharge ?? this.foodServiceCharge,
      foodServiceChargeName: foodServiceChargeName ?? this.foodServiceChargeName,
      gratitudeList: gratitudeList ?? this.gratitudeList,
      deliveryTip: deliveryTip ?? this.deliveryTip,
      extraCharge: extraCharge ?? this.extraCharge,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      packagingCharges: packagingCharges ?? this.packagingCharges,
      packagingChargesTax: packagingChargesTax ?? this.packagingChargesTax,
      grandTotal: grandTotal ?? this.grandTotal,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
