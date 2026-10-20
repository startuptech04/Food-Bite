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

part of 'order_list_bloc.dart';

enum OrderListStatus { loading, success, failure, empty, changeTabs, orderChange, customError }

extension OrderListStatusX on OrderListStatus {
  bool get isLoading => this == OrderListStatus.loading;
  bool get isSuccess => this == OrderListStatus.success;
  bool get isFailure => this == OrderListStatus.failure;
  bool get isEmpty => this == OrderListStatus.empty;
  bool get isChangeTabs => this == OrderListStatus.changeTabs;
  bool get isOrderChange => this == OrderListStatus.orderChange;
  bool get isCustomError => this == OrderListStatus.customError;
}

final class OrderListState {
  final OrderListModel orderList;
  final List<CustomTabListModel>? tabList;
  final String orderChangeId;
  final String newOrderStatus;
  final String activeTab;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final OrderListStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderListState({
    required this.orderList,
    this.tabList = const [],
    this.orderChangeId = '',
    this.newOrderStatus = '',
    this.activeTab = 'new',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = OrderListStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  OrderListState copyWith({
    OrderListModel? orderList,
    List<CustomTabListModel>? tabList,
    String? orderChangeId,
    String? newOrderStatus,
    String? activeTab,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    OrderListStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return OrderListState(
      orderList: orderList ?? this.orderList,
      tabList: tabList ?? this.tabList,
      orderChangeId: orderChangeId ?? this.orderChangeId,
      newOrderStatus: newOrderStatus ?? this.newOrderStatus,
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
