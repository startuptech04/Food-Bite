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

part of 'manage_table_modal_bloc.dart';

sealed class ManageTableModalEvent {}

final class ManageTableModalInitialEvent extends ManageTableModalEvent {
  final bool isNew;
  final String tableId;
  final int tableNumber;
  final int capacity;
  ManageTableModalInitialEvent({required this.isNew, required this.tableId, required this.tableNumber, required this.capacity});
}

final class ManageTableModalNumberChangedEvent extends ManageTableModalEvent {
  final String number;
  ManageTableModalNumberChangedEvent({required this.number});
}

final class ManageTableModalNumberUnfocusedEvent extends ManageTableModalEvent {}

final class ManageTableModalCapacityChangedEvent extends ManageTableModalEvent {
  final String capacity;
  ManageTableModalCapacityChangedEvent({required this.capacity});
}

final class ManageTableModalCapacityUnfocusedEvent extends ManageTableModalEvent {}

final class ManageTableModalSubmitEvent extends ManageTableModalEvent {}
