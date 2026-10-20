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

part of 'order_detail_bloc.dart';

sealed class OrderDetailEvent {}

final class OrderDetailInitialEvent extends OrderDetailEvent {
  final String orderId;
  final String orderNo;
  OrderDetailInitialEvent({required this.orderId, required this.orderNo});
}

final class OrderDetailDirectionEvent extends OrderDetailEvent {
  final double endLat;
  final double endLng;
  OrderDetailDirectionEvent({required this.endLat, required this.endLng});
}

final class OrderDetailMapRedirectEvent extends OrderDetailEvent {}

final class OrderDetailReachRestaurantEvent extends OrderDetailEvent {}

final class OrderDetailPickupViewToggleEvent extends OrderDetailEvent {
  final String toggleView;
  OrderDetailPickupViewToggleEvent({required this.toggleView});
}

final class OrderDetailPickupOrderEvent extends OrderDetailEvent {}

final class OrderDetailDriverReachCustomerEvent extends OrderDetailEvent {}

final class OrderDetailDeliverOrderEvent extends OrderDetailEvent {}

final class OrderDetailCollectMoneyEvent extends OrderDetailEvent {}

final class OrderDetailVerifyCustomerEvent extends OrderDetailEvent {}

final class OrderDetailTrackingLocationEvent extends OrderDetailEvent {}

final class OrderDetailLiveLocationEvent extends OrderDetailEvent {}
