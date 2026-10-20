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
  OrderDetailInitialEvent({required this.id});
}

final class OrderDetailPrepareOrderEvent extends OrderDetailEvent {}

final class OrderDetailCompleteOrderEvent extends OrderDetailEvent {}
