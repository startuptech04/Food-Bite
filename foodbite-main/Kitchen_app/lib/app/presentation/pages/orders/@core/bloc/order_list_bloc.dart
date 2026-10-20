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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/models/api_status_response_model.dart';
import 'package:kitchen/app/core/models/custom_tabs_list_model.dart';
import 'package:kitchen/app/core/models/order_list_model.dart';
import 'package:kitchen/app/core/models/request/order_list_request_model.dart';
import 'package:kitchen/app/core/models/server_error_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/repositories/order_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();
  OrderListBloc()
    : super(
        OrderListState(
          orderList: OrderListModel(locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<OrderListInitialEvent>(_onOrderListInitialEvent);
    on<OrderListLoadMoreEvent>(_onOrderListLoadMoreEvent);
    on<OrderListPullRefreshEvent>(_onOrderListPullRefreshEvent);
    on<OrderListTabChangeEvent>(_onOrderListTabChangeEvent);
    on<OrderListPreparingOrderEvent>(_onOrderListPreparingOrderEvent);
    on<OrderListCompleteOrderEvent>(_onOrderListCompleteOrderEvent);
  }

  FutureOr<void> _onOrderListInitialEvent(OrderListInitialEvent event, Emitter<OrderListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "order_list"}, 'order_list_screen', 'order_list_screen');
      emit(state.copyWith(status: OrderListStatus.loading));
      final String userId = await _orderRepository.userId();
      OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize, page: state.currentPage, owner: userId, status: 'new');
      DioApiResponse response = await _orderRepository.orderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', orderNo: 1, countNumber: data.newOrders!);
        CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', orderNo: 2, countNumber: data.preparingOrders!);
        CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: data.completedOrders!);
        tabsList.add(newOrder);
        tabsList.add(preparingOrder);
        tabsList.add(deliveredOrder);
        emit(state.copyWith(status: data.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty, orderList: data, tabList: tabsList, activeTab: 'new'));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderListLoadMoreEvent(OrderListLoadMoreEvent event, Emitter<OrderListState> emit) async {
    if (state.orderList.orders!.length < state.orderList.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String userId = await _orderRepository.userId();
        OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize * 2, page: state.currentPage, owner: userId, status: state.activeTab);
        DioApiResponse response = await _orderRepository.orderList(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _authRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
          List<CustomTabListModel> tabsList = <CustomTabListModel>[];
          tabsList.clear();
          CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', orderNo: 1, countNumber: data.newOrders!);
          CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', orderNo: 2, countNumber: data.preparingOrders!);
          CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: data.completedOrders!);
          tabsList.add(newOrder);
          tabsList.add(preparingOrder);
          tabsList.add(deliveredOrder);
          emit(state.copyWith(status: data.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty, orderList: data, tabList: tabsList, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString(), loadMore: false));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrderListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onOrderListPullRefreshEvent(OrderListPullRefreshEvent event, Emitter<OrderListState> emit) async {
    try {
      emit(state.copyWith(status: OrderListStatus.loading, pageSize: ApiRequestService.pageSize));
      final String userId = await _orderRepository.userId();
      OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize, page: state.currentPage, owner: userId, status: state.activeTab);
      DioApiResponse response = await _orderRepository.orderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', orderNo: 1, countNumber: data.newOrders!);
        CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', orderNo: 2, countNumber: data.preparingOrders!);
        CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: data.completedOrders!);
        tabsList.add(newOrder);
        tabsList.add(preparingOrder);
        tabsList.add(deliveredOrder);
        emit(state.copyWith(status: data.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty, orderList: data, tabList: tabsList));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderListTabChangeEvent(OrderListTabChangeEvent event, Emitter<OrderListState> emit) async {
    try {
      emit(state.copyWith(status: OrderListStatus.changeTabs, activeTab: event.key));
      final String userId = await _orderRepository.userId();
      OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize, page: state.currentPage, owner: userId, status: event.key);
      DioApiResponse response = await _orderRepository.orderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', orderNo: 1, countNumber: data.newOrders!);
        CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', orderNo: 2, countNumber: data.preparingOrders!);
        CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Completed (##dynamic##)', key: 'completed', orderNo: 3, countNumber: data.completedOrders!);
        tabsList.add(newOrder);
        tabsList.add(preparingOrder);
        tabsList.add(deliveredOrder);
        emit(state.copyWith(status: data.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty, orderList: data, tabList: tabsList));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderListPreparingOrderEvent(OrderListPreparingOrderEvent event, Emitter<OrderListState> emit) async {
    try {
      emit(state.copyWith(status: OrderListStatus.orderChange, newOrderStatus: 'prepareSchedule', orderChangeId: state.orderList.orders![event.orderIndex].id));
      DioApiResponse response = await _orderRepository.prepareOrder(state.orderList.orders![event.orderIndex].id!);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          if (state.orderList.newOrders! == 1) {
            state.orderList.newOrders = 0;
          } else {
            state.orderList.newOrders = state.orderList.newOrders! - 1;
          }
          state.orderList.preparingOrders = state.orderList.preparingOrders! + 1;
          final int newTabIndex = state.tabList!.indexWhere((element) => element.key == 'new');
          final int preparingTabIndex = state.tabList!.indexWhere((element) => element.key == 'preparing');
          if (newTabIndex != -1) {
            state.tabList![newTabIndex].label = "New (##dynamic##)";
            state.tabList![newTabIndex].countNumber = state.orderList.newOrders!;
          }
          if (preparingTabIndex != -1) {
            state.tabList![preparingTabIndex].label = "Preparing (##dynamic##)";
            state.tabList![preparingTabIndex].countNumber = state.orderList.preparingOrders!;
          }
          state.orderList.orders!.removeAt(event.orderIndex);
          emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty));
        } else {
          emit(state.copyWith(status: OrderListStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderListStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderListCompleteOrderEvent(OrderListCompleteOrderEvent event, Emitter<OrderListState> emit) async {
    try {
      emit(state.copyWith(status: OrderListStatus.orderChange, newOrderStatus: 'completeOrder', orderChangeId: state.orderList.orders![event.orderIndex].id));
      DioApiResponse response = await _orderRepository.completeOrder(state.orderList.orders![event.orderIndex].id!);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          if (state.orderList.preparingOrders! == 1) {
            state.orderList.preparingOrders = 0;
          } else {
            state.orderList.preparingOrders = state.orderList.preparingOrders! - 1;
          }
          state.orderList.completedOrders = state.orderList.completedOrders! + 1;
          final int preparingIndex = state.tabList!.indexWhere((element) => element.key == 'preparing');
          final int completedIndex = state.tabList!.indexWhere((element) => element.key == 'completed');
          if (preparingIndex != -1) {
            state.tabList![preparingIndex].label = "Preparing (##dynamic##)";
            state.tabList![preparingIndex].countNumber = state.orderList.preparingOrders!;
          }
          if (completedIndex != -1) {
            state.tabList![completedIndex].label = "Completed (##dynamic##)";
            state.tabList![completedIndex].countNumber = state.orderList.completedOrders!;
          }
          state.orderList.orders!.removeAt(event.orderIndex);
          emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrderListStatus.success : OrderListStatus.empty));
        } else {
          emit(state.copyWith(status: OrderListStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrderListStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
