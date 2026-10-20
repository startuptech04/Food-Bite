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

part of 'order_coupon_list_bloc.dart';

sealed class OrderCouponListEvent {}

final class OrderCouponListInitialEvent extends OrderCouponListEvent {}

final class OrderCouponListLoadMoreEvent extends OrderCouponListEvent {}

final class OrderCouponListChangeStatusEvent extends OrderCouponListEvent {
  final int index;
  OrderCouponListChangeStatusEvent({required this.index});
}

final class OrderCouponListDeleteEvent extends OrderCouponListEvent {
  final int index;
  OrderCouponListDeleteEvent({required this.index});
}
