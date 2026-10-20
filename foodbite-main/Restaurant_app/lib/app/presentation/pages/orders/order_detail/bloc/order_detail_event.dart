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
  final String id;
  final int orderNo;
  OrderDetailInitialEvent({required this.id, required this.orderNo});
}

final class OrderDetailCallCustomerEvent extends OrderDetailEvent {}

final class OrderDetailCallDeliverymanEvent extends OrderDetailEvent {}

final class OrderDetailRejectOrderEvent extends OrderDetailEvent {
  final String reasonId;
  OrderDetailRejectOrderEvent({required this.reasonId});
}

final class OrderDetailAcceptOrderEvent extends OrderDetailEvent {
  final String driverId;
  OrderDetailAcceptOrderEvent({required this.driverId});
}

final class OrderDetailPreparationTimeChangeEvent extends OrderDetailEvent {
  final String action;
  OrderDetailPreparationTimeChangeEvent({required this.action});
}

final class OrderDetailAcceptScheduleOrderEvent extends OrderDetailEvent {
  final String driverId;
  OrderDetailAcceptScheduleOrderEvent({required this.driverId});
}

final class OrderDetailReadyEvent extends OrderDetailEvent {}

final class OrderDetailHandoverOrderEvent extends OrderDetailEvent {}
