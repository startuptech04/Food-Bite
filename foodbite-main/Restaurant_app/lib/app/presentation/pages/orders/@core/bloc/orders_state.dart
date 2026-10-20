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

part of 'orders_bloc.dart';

enum OrdersStatus { loading, success, failure, empty, changeTabs, orderChange, customError }

extension OrdersStatusX on OrdersStatus {
  bool get isLoading => this == OrdersStatus.loading;
  bool get isSuccess => this == OrdersStatus.success;
  bool get isFailure => this == OrdersStatus.failure;
  bool get isEmpty => this == OrdersStatus.empty;
  bool get isChangeTabs => this == OrdersStatus.changeTabs;
  bool get isOrderChange => this == OrdersStatus.orderChange;
  bool get isCustomError => this == OrdersStatus.customError;
}

final class OrdersState {
  final OrderListModel orderList;
  final List<CustomTabListModel>? tabList;
  final String orderChangeId;
  final String newOrderStatus;
  final bool ownDriver;
  final String activeTab;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final OrdersStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrdersState({
    required this.orderList,
    this.tabList = const [],
    this.orderChangeId = '',
    this.newOrderStatus = '',
    this.ownDriver = false,
    this.activeTab = 'new',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = OrdersStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  OrdersState copyWith({
    OrderListModel? orderList,
    List<CustomTabListModel>? tabList,
    String? orderChangeId,
    String? newOrderStatus,
    bool? ownDriver,
    String? activeTab,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    OrdersStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return OrdersState(
      orderList: orderList ?? this.orderList,
      tabList: tabList ?? this.tabList,
      orderChangeId: orderChangeId ?? this.orderChangeId,
      newOrderStatus: newOrderStatus ?? this.newOrderStatus,
      ownDriver: ownDriver ?? this.ownDriver,
      activeTab: activeTab ?? this.activeTab,
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
