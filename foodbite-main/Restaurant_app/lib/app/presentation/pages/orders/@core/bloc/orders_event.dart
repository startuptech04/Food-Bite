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

part of 'orders_bloc.dart';

sealed class OrdersEvent {}

final class OrdersInitialEvent extends OrdersEvent {}

final class OrdersTabChangeEvent extends OrdersEvent {
  final String key;
  OrdersTabChangeEvent({required this.key});
}

final class OrdersPreparationTimeChangeEvent extends OrdersEvent {
  final String action;
  final int orderIndex;
  OrdersPreparationTimeChangeEvent({required this.action, required this.orderIndex});
}

final class OrdersAcceptNewOrderEvent extends OrdersEvent {
  final int orderIndex;
  final String driverId;
  OrdersAcceptNewOrderEvent({required this.orderIndex, required this.driverId});
}

final class OrdersRejectEvent extends OrdersEvent {
  final int orderIndex;
  final String reasonId;
  OrdersRejectEvent({required this.orderIndex, required this.reasonId});
}

final class OrdersAcceptScheduleOrderEvent extends OrdersEvent {
  final int orderIndex;
  final String driverId;
  OrdersAcceptScheduleOrderEvent({required this.orderIndex, required this.driverId});
}

final class OrderReadyEvent extends OrdersEvent {
  final int orderIndex;
  OrderReadyEvent({required this.orderIndex});
}

final class OrderHandOverEvent extends OrdersEvent {
  final int orderIndex;
  OrderHandOverEvent({required this.orderIndex});
}

final class OrderLoadMoreEvent extends OrdersEvent {}

final class OrderPullRefreshEvent extends OrdersEvent {}

final class OrderCloseTemporaryEvent extends OrdersEvent {}

final class ReOpenRestaurantEvent extends OrdersEvent {}
