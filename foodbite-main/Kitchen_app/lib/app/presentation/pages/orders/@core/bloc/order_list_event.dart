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

part of 'order_list_bloc.dart';

sealed class OrderListEvent {}

final class OrderListInitialEvent extends OrderListEvent {}

final class OrderListLoadMoreEvent extends OrderListEvent {}

final class OrderListPullRefreshEvent extends OrderListEvent {}

final class OrderListTabChangeEvent extends OrderListEvent {
  final String key;
  OrderListTabChangeEvent({required this.key});
}

final class OrderListPreparingOrderEvent extends OrderListEvent {
  final int orderIndex;
  OrderListPreparingOrderEvent({required this.orderIndex});
}

final class OrderListCompleteOrderEvent extends OrderListEvent {
  final int orderIndex;
  OrderListCompleteOrderEvent({required this.orderIndex});
}
