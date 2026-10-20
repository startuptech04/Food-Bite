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

part of 'new_order_bloc.dart';

sealed class NewOrderEvent {}

final class NewOrderInitialEvent extends NewOrderEvent {
  final String orderFrom;
  NewOrderInitialEvent({required this.orderFrom});
}

final class NewOrderRejectEvent extends NewOrderEvent {
  final String reasonId;
  NewOrderRejectEvent({required this.reasonId});
}

final class NewOrderAcceptEvent extends NewOrderEvent {}
