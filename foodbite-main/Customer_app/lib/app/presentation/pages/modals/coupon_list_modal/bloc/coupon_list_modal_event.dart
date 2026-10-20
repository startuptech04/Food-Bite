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

sealed class CouponListModalEvent {}

final class CouponListModalInitialEvent extends CouponListModalEvent {
  final String restaurant;
  final double itemTotal;
  final double latitude;
  final double longitude;
  final String trackingId;
  CouponListModalInitialEvent({required this.restaurant, required this.itemTotal, required this.latitude, required this.longitude, required this.trackingId});
}

final class CouponListModalOpenDiscriptionEvent extends CouponListModalEvent {
  final int index;
  CouponListModalOpenDiscriptionEvent({required this.index});
}

final class CouponListModalSelectCouponEvent extends CouponListModalEvent {
  final int index;
  CouponListModalSelectCouponEvent({required this.index});
}
