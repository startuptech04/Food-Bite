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

part of 'dining_pre_booking_bloc.dart';

enum DiningPreBookingStatus { loading, success, failure, empty, changeTabs, orderChange, customError }

extension DiningPreBookingStatusX on DiningPreBookingStatus {
  bool get isLoading => this == DiningPreBookingStatus.loading;
  bool get isSuccess => this == DiningPreBookingStatus.success;
  bool get isFailure => this == DiningPreBookingStatus.failure;
  bool get isChangeTabs => this == DiningPreBookingStatus.changeTabs;
  bool get isEmpty => this == DiningPreBookingStatus.empty;
  bool get isOrderChange => this == DiningPreBookingStatus.orderChange;
  bool get isCustomError => this == DiningPreBookingStatus.customError;
}

final class DiningPreBookingState {
  final DiningBookingResponseListModel model;
  final List<CustomTabListModel>? tabList;
  final String orderChangeId;
  final String newOrderStatus;
  final String activeTab;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final DiningPreBookingStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningPreBookingState({
    required this.model,
    this.tabList = const [],
    this.orderChangeId = '',
    this.newOrderStatus = '',
    this.activeTab = '',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = DiningPreBookingStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DiningPreBookingState copyWith({
    DiningBookingResponseListModel? model,
    List<CustomTabListModel>? tabList,
    String? orderChangeId,
    String? newOrderStatus,
    String? activeTab,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    DiningPreBookingStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return DiningPreBookingState(
      model: model ?? this.model,
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
