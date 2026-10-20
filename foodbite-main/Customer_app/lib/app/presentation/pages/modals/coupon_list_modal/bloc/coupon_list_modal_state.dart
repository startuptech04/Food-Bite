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

part of 'coupon_list_modal_bloc.dart';

enum CouponListModalStatus { loading, success, failure, empty, validationFailure, couponRedeemStart, couponRedeemSuccess, couponRedeemFailed }

extension CouponListModalStatusX on CouponListModalStatus {
  bool get isLoading => this == CouponListModalStatus.loading;
  bool get isSuccess => this == CouponListModalStatus.success;
  bool get isFailure => this == CouponListModalStatus.failure;
  bool get isEmpty => this == CouponListModalStatus.empty;
  bool get isValidationFailure => this == CouponListModalStatus.validationFailure;
  bool get isCouponRedeemStart => this == CouponListModalStatus.couponRedeemStart;
  bool get isCouponRedeemSuccess => this == CouponListModalStatus.couponRedeemSuccess;
  bool get isCouponRedeemFailed => this == CouponListModalStatus.couponRedeemFailed;
}

final class CouponListModalState {
  final CouponListResponseModel coupons;
  final String trackingId;
  final String restaurant;
  final double itemTotal;
  final int redeemCouponIndex;
  final CouponListModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CouponListModalState({
    required this.coupons,
    this.trackingId = '',
    this.restaurant = '',
    this.itemTotal = 0,
    this.redeemCouponIndex = 0,
    this.status = CouponListModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  CouponListModalState copyWith({
    CouponListResponseModel? coupons,
    String? trackingId,
    String? restaurant,
    double? itemTotal,
    int? redeemCouponIndex,
    CouponListModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return CouponListModalState(
      coupons: coupons ?? this.coupons,
      trackingId: trackingId ?? this.trackingId,
      restaurant: restaurant ?? this.restaurant,
      itemTotal: itemTotal ?? this.itemTotal,
      redeemCouponIndex: redeemCouponIndex ?? this.redeemCouponIndex,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
