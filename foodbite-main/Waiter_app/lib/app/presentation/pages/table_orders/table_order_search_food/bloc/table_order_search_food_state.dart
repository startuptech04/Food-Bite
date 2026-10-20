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

part of 'table_order_search_food_bloc.dart';

enum TableOrderSearchFoodStatus { initial, empty, success, failure, initialCartUpdate, initialCartError, searchCartUpdate, searchCartError, cartError, customError }

extension TableOrderSearchFoodStatusX on TableOrderSearchFoodStatus {
  bool get isInitial => this == TableOrderSearchFoodStatus.initial;
  bool get isSuccess => this == TableOrderSearchFoodStatus.success;
  bool get isFailure => this == TableOrderSearchFoodStatus.failure;
  bool get isEmpty => this == TableOrderSearchFoodStatus.empty;
  bool get isInitialCartUpdate => this == TableOrderSearchFoodStatus.initialCartUpdate;
  bool get isInitialCartError => this == TableOrderSearchFoodStatus.initialCartError;
  bool get isSearchCartUpdate => this == TableOrderSearchFoodStatus.searchCartUpdate;
  bool get isSearchCartError => this == TableOrderSearchFoodStatus.searchCartError;
  bool get isCartError => this == TableOrderSearchFoodStatus.cartError;
  bool get isCustomError => this == TableOrderSearchFoodStatus.customError;
}

final class TableOrderSearchFoodState {
  final String appLocale;
  final int tableNumber;
  final String tableId;
  final PosFoodSearchInitialResponseModel initialData;
  final PosFoodSearchResultResponseModel response;
  final TableOrderSearchFoodStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const TableOrderSearchFoodState({
    this.appLocale = '',
    this.tableNumber = 0,
    this.tableId = '',
    required this.initialData,
    required this.response,
    this.status = TableOrderSearchFoodStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  TableOrderSearchFoodState copyWith({
    String? appLocale,
    int? tableNumber,
    String? tableId,
    PosFoodSearchInitialResponseModel? initialData,
    PosFoodSearchResultResponseModel? response,
    TableOrderSearchFoodStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return TableOrderSearchFoodState(
      appLocale: appLocale ?? this.appLocale,
      tableNumber: tableNumber ?? this.tableNumber,
      tableId: tableId ?? this.tableId,
      initialData: initialData ?? this.initialData,
      response: response ?? this.response,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
