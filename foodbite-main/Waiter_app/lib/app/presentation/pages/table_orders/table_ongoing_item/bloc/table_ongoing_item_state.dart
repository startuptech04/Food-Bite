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

enum TableOngoingItemStatus { loading, empty, success, failure }

extension TableOngoingItemStatusX on TableOngoingItemStatus {
  bool get isLoading => this == TableOngoingItemStatus.loading;
  bool get isEmpty => this == TableOngoingItemStatus.empty;
  bool get isSuccess => this == TableOngoingItemStatus.success;
  bool get isFailure => this == TableOngoingItemStatus.failure;
}

final class TableOngoingItemState {
  final int tableNumber;
  final String tableId;
  final TableOngoingCartItemModel model;
  final TableOngoingItemStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const TableOngoingItemState({this.tableNumber = 0, this.tableId = '', required this.model, this.status = TableOngoingItemStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  TableOngoingItemState copyWith({int? tableNumber, String? tableId, TableOngoingCartItemModel? model, TableOngoingItemStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return TableOngoingItemState(
      tableNumber: tableNumber ?? this.tableNumber,
      tableId: tableId ?? this.tableId,
      model: model ?? this.model,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
