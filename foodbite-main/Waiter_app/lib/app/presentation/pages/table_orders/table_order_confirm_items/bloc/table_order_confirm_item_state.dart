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

enum TableOrderConfirmItemStatus { loading, initial, empty, success, failure, customError, cartUpdate, cartError, removeDiscount, placingOrder, orderPlaced }

extension TableOrderConfirmItemStatusX on TableOrderConfirmItemStatus {
  bool get isLoading => this == TableOrderConfirmItemStatus.loading;
  bool get isInitial => this == TableOrderConfirmItemStatus.initial;
  bool get isEmpty => this == TableOrderConfirmItemStatus.empty;
  bool get isSuccess => this == TableOrderConfirmItemStatus.success;
  bool get isFailure => this == TableOrderConfirmItemStatus.failure;
  bool get isCustomError => this == TableOrderConfirmItemStatus.customError;
  bool get isCartUpdate => this == TableOrderConfirmItemStatus.cartUpdate;
  bool get isCartError => this == TableOrderConfirmItemStatus.cartError;
  bool get isRemoveDiscount => this == TableOrderConfirmItemStatus.removeDiscount;
  bool get isPlacingOrder => this == TableOrderConfirmItemStatus.placingOrder;
  bool get isOrderPlaced => this == TableOrderConfirmItemStatus.orderPlaced;
}

final class TableOrderConfirmItemState {
  final int tableNumber;
  final String tableId;
  final TableOngoingCartItemModel model;
  final List<PosFoodInCartModel> inCart;
  final TableOrderConfirmItemStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const TableOrderConfirmItemState({
    this.tableNumber = 0,
    this.tableId = '',
    required this.model,
    this.inCart = const [],
    this.status = TableOrderConfirmItemStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  TableOrderConfirmItemState copyWith({
    int? tableNumber,
    String? tableId,
    TableOngoingCartItemModel? model,
    List<PosFoodInCartModel>? inCart,
    TableOrderConfirmItemStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return TableOrderConfirmItemState(
      tableNumber: tableNumber ?? this.tableNumber,
      tableId: tableId ?? this.tableId,
      model: model ?? this.model,
      inCart: inCart ?? this.inCart,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
