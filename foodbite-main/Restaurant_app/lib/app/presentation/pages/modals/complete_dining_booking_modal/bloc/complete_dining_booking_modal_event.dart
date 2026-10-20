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

sealed class CompleteDiningBookingModalEvent {}

final class CompleteDiningBookingModalInitialEvent extends CompleteDiningBookingModalEvent {
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
  CompleteDiningBookingModalInitialEvent({
    required this.bookingId,
    required this.userName,
    required this.bookingDate,
    required this.contactNumber,
    required this.couponCoverCharge,
    required this.grandTotal,
    required this.couponId,
    required this.couponCode,
    required this.couponDiscountType,
    required this.couponMinDiscount,
    required this.couponMaxDiscount,
  });
}

final class CompleteDiningBookingModalBillingTotalChangedEvent extends CompleteDiningBookingModalEvent {
  final String total;
  CompleteDiningBookingModalBillingTotalChangedEvent({required this.total});
}

final class CompleteDiningBookingModalDiscountChangedEvent extends CompleteDiningBookingModalEvent {
  final String discount;
  CompleteDiningBookingModalDiscountChangedEvent({required this.discount});
}

final class CompleteDiningBookingModalDiscountTypeChangedEvent extends CompleteDiningBookingModalEvent {
  final String value;
  CompleteDiningBookingModalDiscountTypeChangedEvent({required this.value});
}

final class CompleteDiningBookingModalCouponPercentageChangeEvent extends CompleteDiningBookingModalEvent {
  final double couponDiscountPercentage;
  CompleteDiningBookingModalCouponPercentageChangeEvent({required this.couponDiscountPercentage});
}

final class CompleteDiningBookingModalCalculateBillingEvent extends CompleteDiningBookingModalEvent {}

final class CompleteDiningBookingModalSubmitEvent extends CompleteDiningBookingModalEvent {}
