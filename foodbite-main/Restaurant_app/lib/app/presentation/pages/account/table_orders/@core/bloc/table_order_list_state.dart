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

enum TableOrderListStatus { loading, success, failure, customError, empty }

extension TableOrderListStatusX on TableOrderListStatus {
  bool get isLoading => this == TableOrderListStatus.loading;
  bool get isSuccess => this == TableOrderListStatus.success;
  bool get isFailure => this == TableOrderListStatus.failure;
  bool get isCustomError => this == TableOrderListStatus.customError;
  bool get isEmpty => this == TableOrderListStatus.empty;
}

final class TableOrderListState {
  final String activeTab;
  final List<CustomTabListModel>? tabList;
  final OngoingTableOrderModel ongoingOrder;
  final CompletedTableOrderListModel completedOrders;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final TableOrderListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TableOrderListState({
    this.activeTab = 'ongoing',
    this.tabList = const [],
    required this.ongoingOrder,
    required this.completedOrders,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = TableOrderListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  TableOrderListState copyWith({
    String? activeTab,
    List<CustomTabListModel>? tabList,
    OngoingTableOrderModel? ongoingOrder,
    CompletedTableOrderListModel? completedOrders,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    TableOrderListStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return TableOrderListState(
      activeTab: activeTab ?? this.activeTab,
      tabList: tabList ?? this.tabList,
      ongoingOrder: ongoingOrder ?? this.ongoingOrder,
      completedOrders: completedOrders ?? this.completedOrders,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
