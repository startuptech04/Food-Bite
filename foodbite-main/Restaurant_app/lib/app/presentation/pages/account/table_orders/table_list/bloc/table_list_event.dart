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

part of 'table_list_bloc.dart';

sealed class TableListEvent {}

final class TableListInitialEvent extends TableListEvent {}

final class TableListLoadMoreEvent extends TableListEvent {}

final class TableListChangeStatusEvent extends TableListEvent {
  final int index;
  TableListChangeStatusEvent({required this.index});
}

final class TableListDeleteTableEvent extends TableListEvent {
  final int index;
  TableListDeleteTableEvent({required this.index});
}
