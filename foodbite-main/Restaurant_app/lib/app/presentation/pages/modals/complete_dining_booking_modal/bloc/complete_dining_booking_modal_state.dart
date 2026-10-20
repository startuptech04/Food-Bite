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

part of 'complete_dining_booking_modal_bloc.dart';

enum CompleteDiningBookingModalStatus { initial, complete, completeSuccess, customError }

extension CompleteDiningBookingModalStateX on CompleteDiningBookingModalStatus {
  bool get isInitial => this == CompleteDiningBookingModalStatus.initial;
  bool get isComplete => this == CompleteDiningBookingModalStatus.complete;
  bool get isCompleteSuccess => this == CompleteDiningBookingModalStatus.completeSuccess;
  bool get isCustomError => this == CompleteDiningBookingModalStatus.customError;
}

final class CompleteDiningBookingModalState {
  final String bookingId;
  final String userName;
  final String bookingDate;
  final String contactNumber;
  final double couponCoverCharge;
  final double grandTotal;
  final String couponId;
  final String couponCode;
  final String couponDiscountType;
  final double couponMinDiscount;
  final double couponMaxDiscount;
  final double couponSelectedPercentageDiscount;
  final double diningItemTotalAmount;
  final double diningItemDiscountValue;
  final double diningItemDiscountAmount;
  final double diningCouponDiscountAmount;
  final double diningGrandTotalBillAmount;
  final String discountType;
  final List<CompleteDiningBookingModalDiscountTypeModel> discountTypeList;
  final CompleteDiningBookingModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CompleteDiningBookingModalState({
    this.bookingId = '',
    this.userName = '',
    this.bookingDate = '',
    this.contactNumber = '',
    this.couponCoverCharge = 0,
    this.grandTotal = 0,
    this.couponId = '',
    this.couponCode = '',
    this.couponDiscountType = '',
    this.couponMinDiscount = 0,
    this.couponMaxDiscount = 0,
    this.couponSelectedPercentageDiscount = 0,
    this.diningItemTotalAmount = 0,
    this.diningItemDiscountValue = 0,
    this.diningItemDiscountAmount = 0,
    this.diningCouponDiscountAmount = 0,
    this.diningGrandTotalBillAmount = 0,
    this.discountType = '',
    this.discountTypeList = const [],
    this.status = CompleteDiningBookingModalStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  CompleteDiningBookingModalState copyWith({
    String? bookingId,
    String? userName,
    String? bookingDate,
    String? contactNumber,
    double? couponCoverCharge,
    double? grandTotal,
    String? couponId,
    String? couponCode,
    String? couponDiscountType,
    double? couponMinDiscount,
    double? couponMaxDiscount,
    double? couponSelectedPercentageDiscount,
    double? diningItemTotalAmount,
    double? diningItemDiscountValue,
    double? diningItemDiscountAmount,
    double? diningCouponDiscountAmount,
    double? diningGrandTotalBillAmount,
    String? discountType,
    List<CompleteDiningBookingModalDiscountTypeModel>? discountTypeList,
    CompleteDiningBookingModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return CompleteDiningBookingModalState(
      bookingId: bookingId ?? this.bookingId,
      userName: userName ?? this.userName,
      bookingDate: bookingDate ?? this.bookingDate,
      contactNumber: contactNumber ?? this.contactNumber,
      couponCoverCharge: couponCoverCharge ?? this.couponCoverCharge,
      grandTotal: grandTotal ?? this.grandTotal,
      couponId: couponId ?? this.couponId,
      couponCode: couponCode ?? this.couponCode,
      couponDiscountType: couponDiscountType ?? this.couponDiscountType,
      couponMinDiscount: couponMinDiscount ?? this.couponMinDiscount,
      couponMaxDiscount: couponMaxDiscount ?? this.couponMaxDiscount,
      couponSelectedPercentageDiscount: couponSelectedPercentageDiscount ?? this.couponSelectedPercentageDiscount,
      diningItemTotalAmount: diningItemTotalAmount ?? this.diningItemTotalAmount,
      diningItemDiscountValue: diningItemDiscountValue ?? this.diningItemDiscountValue,
      diningItemDiscountAmount: diningItemDiscountAmount ?? this.diningItemDiscountAmount,
      diningCouponDiscountAmount: diningCouponDiscountAmount ?? this.diningCouponDiscountAmount,
      diningGrandTotalBillAmount: diningGrandTotalBillAmount ?? this.diningGrandTotalBillAmount,
      discountType: discountType ?? this.discountType,
      discountTypeList: discountTypeList ?? this.discountTypeList,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}

class CompleteDiningBookingModalDiscountTypeModel {
  String? label;
  String? value;

  CompleteDiningBookingModalDiscountTypeModel({this.label, this.value});

  CompleteDiningBookingModalDiscountTypeModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
