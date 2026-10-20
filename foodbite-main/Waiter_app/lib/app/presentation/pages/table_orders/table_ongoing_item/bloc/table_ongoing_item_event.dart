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

part of 'table_ongoing_item_bloc.dart';

sealed class TableOngoingItemEvent {}

final class TableOngoingItemInitialEvent extends TableOngoingItemEvent {
  final int tableNumber;
  final String tableId;
  TableOngoingItemInitialEvent({required this.tableNumber, required this.tableId});
}
