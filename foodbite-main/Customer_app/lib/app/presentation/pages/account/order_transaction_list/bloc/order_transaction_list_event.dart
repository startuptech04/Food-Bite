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

part of 'order_transaction_list_bloc.dart';

sealed class OrderTransactionListEvent {}

final class OrderTransactionListInitialEvent extends OrderTransactionListEvent {}

final class OrderTransactionListLoadMoreOrderTransactionEvent extends OrderTransactionListEvent {}

final class OrderTransactionListPullRefreshEvent extends OrderTransactionListEvent {}
