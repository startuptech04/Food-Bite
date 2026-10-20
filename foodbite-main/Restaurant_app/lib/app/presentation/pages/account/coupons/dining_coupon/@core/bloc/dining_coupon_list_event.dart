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

part of 'dining_coupon_list_bloc.dart';

sealed class DiningCouponListEvent {}

final class DiningCouponListInitialEvent extends DiningCouponListEvent {}

final class DiningCouponListLoadMoreEvent extends DiningCouponListEvent {}

final class DiningCouponListChangeStatusEvent extends DiningCouponListEvent {
  final int index;
  DiningCouponListChangeStatusEvent({required this.index});
}

final class DiningCouponListDeleteEvent extends DiningCouponListEvent {
  final int index;
  DiningCouponListDeleteEvent({required this.index});
}
