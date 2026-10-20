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

part of 'table_order_confirm_item_bloc.dart';

sealed class TableOrderConfirmItemEvent {}

final class TableOrderConfirmItemInitialEvent extends TableOrderConfirmItemEvent {
  final int tableNumber;
  final String tableId;
  TableOrderConfirmItemInitialEvent({required this.tableNumber, required this.tableId});
}

final class TableOrderConfirmItemQuantityEvent extends TableOrderConfirmItemEvent {
  final String id;
  final String uuid;
  final String action;
  TableOrderConfirmItemQuantityEvent({required this.id, required this.uuid, required this.action});
}

final class TableOrderConfirmItemSubmitEvent extends TableOrderConfirmItemEvent {}
