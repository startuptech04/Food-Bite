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

part of 'table_order_dashboard_bloc.dart';

enum TableOrderDashboardStatus { loading, success, failure, empty, customError, cartUpdate, cartError }

extension TableOrderDashboardStatusX on TableOrderDashboardStatus {
  bool get isLoading => this == TableOrderDashboardStatus.loading;
  bool get isSuccess => this == TableOrderDashboardStatus.success;
  bool get isFailure => this == TableOrderDashboardStatus.failure;
  bool get isEmpty => this == TableOrderDashboardStatus.empty;
  bool get isCustomError => this == TableOrderDashboardStatus.customError;
  bool get isCartUpdate => this == TableOrderDashboardStatus.cartUpdate;
  bool get isCartError => this == TableOrderDashboardStatus.cartError;
}

final class TableOrderDashboardState {
  final String appLocale;
  final int tableNumber;
  final String tableId;
  final PosOrderModel model;
  final List<PosRestaurantModalCategoryModel> category;
  final Map<String, GlobalKey> globalMainCategoriesKey;
  final String categoryInView;
  final int cartTotalItem;
  final TableOrderDashboardStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const TableOrderDashboardState({
    this.appLocale = '',
    this.tableNumber = 0,
    this.tableId = '',
    required this.model,
    this.category = const [],
    this.globalMainCategoriesKey = const {},
    this.categoryInView = '',
    this.cartTotalItem = 0,
    this.status = TableOrderDashboardStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  TableOrderDashboardState copyWith({
    String? appLocale,
    int? tableNumber,
    String? tableId,
    PosOrderModel? model,
    List<PosRestaurantModalCategoryModel>? category,
    Map<String, GlobalKey>? globalMainCategoriesKey,
    String? categoryInView,
    int? cartTotalItem,
    TableOrderDashboardStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return TableOrderDashboardState(
      appLocale: appLocale ?? this.appLocale,
      tableNumber: tableNumber ?? this.tableNumber,
      tableId: tableId ?? this.tableId,
      model: model ?? this.model,
      category: category ?? this.category,
      globalMainCategoriesKey: globalMainCategoriesKey ?? this.globalMainCategoriesKey,
      categoryInView: categoryInView ?? this.categoryInView,
      cartTotalItem: cartTotalItem ?? this.cartTotalItem,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
