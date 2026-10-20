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

part of 'table_order_list_bloc.dart';

sealed class TableOrderListEvent {}

final class TableOrderListInitialEvent extends TableOrderListEvent {}

final class TableOrderListTabChangeEvent extends TableOrderListEvent {
  final String key;
  TableOrderListTabChangeEvent({required this.key});
}

final class TableOrderListRefreshTableEvent extends TableOrderListEvent {}

final class TableOrderListFetchCompletedOrderEvent extends TableOrderListEvent {}

final class TableOrderListFetchMoreCompletedOrderEvent extends TableOrderListEvent {}

final class TableOrderListPullRefreshEvent extends TableOrderListEvent {}
