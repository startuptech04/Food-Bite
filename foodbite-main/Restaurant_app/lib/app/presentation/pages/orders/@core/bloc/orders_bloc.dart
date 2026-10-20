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
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/custom_tabs_list_model.dart';
import 'package:vendor/app/core/models/order_list_model.dart';
import 'package:vendor/app/core/models/request/accept_schedule_order_request_model.dart';
import 'package:vendor/app/core/models/request/order_handover_to_customer_request_model.dart';
import 'package:vendor/app/core/models/request/order_handover_to_driver_request_model.dart';
import 'package:vendor/app/core/models/request/order_list_request_model.dart';
import 'package:vendor/app/core/models/request/order_ready_request_model.dart';
import 'package:vendor/app/core/models/request/prepare_order_request_model.dart';
import 'package:vendor/app/core/models/request/reject_order_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  OrdersBloc()
    : super(
        OrdersState(
          orderList: OrderListModel(locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<OrdersInitialEvent>(_onOrdersInitialEvent);
    on<OrdersTabChangeEvent>(_onOrdersTabChangeEvent);
    on<OrdersPreparationTimeChangeEvent>(_onOrdersPreparationTimeChangeEvent);
    on<OrdersAcceptNewOrderEvent>(_onOrdersAcceptNewOrderEvent);
    on<OrdersRejectEvent>(_onOrdersRejectEvent);
    on<OrdersAcceptScheduleOrderEvent>(_onOrdersAcceptScheduleOrderEvent);
    on<OrderReadyEvent>(_onOrderReadyEvent);
    on<OrderHandOverEvent>(_onOrderHandOverEvent);
    on<OrderLoadMoreEvent>(_onOrderLoadMoreEvent);
    on<OrderPullRefreshEvent>(_onOrderPullRefreshEvent);
    on<OrderCloseTemporaryEvent>(_onOrderCloseTemporaryEvent);
    on<ReOpenRestaurantEvent>(_onReOpenRestaurantEvent);
  }

  Future<void> _onOrdersInitialEvent(OrdersInitialEvent event, Emitter<OrdersState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "order_history_list"}, 'order_history_list_screen', 'order_history_list_screen');
      final bool haveOwnDriver = await _orderRepository.haveOwnDriver();
      emit(state.copyWith(status: OrdersStatus.loading, ownDriver: haveOwnDriver));
      final String vendorId = await _orderRepository.getVendorId();
      OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize, page: state.currentPage, vendorId: vendorId, status: 'new');
      DioApiResponse response = await _orderRepository.getOrderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', orderNo: 1, countNumber: data.newOrders!);
        CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', orderNo: 2, countNumber: data.preparingOrders!);
        CustomTabListModel readyOrder = CustomTabListModel(label: 'Ready (##dynamic##)', key: 'ready', orderNo: 3, countNumber: data.readyOrder!);
        CustomTabListModel handOverOrder = CustomTabListModel(label: 'Pickd up (##dynamic##)', key: 'handover', orderNo: 4, countNumber: data.handOverOrder!);
        CustomTabListModel ongoingOrder = CustomTabListModel(label: 'Ongoing (##dynamic##)', key: 'ongoing', orderNo: 5, countNumber: data.ongoingOrder!);
        CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Delivered (##dynamic##)', key: 'delivered', orderNo: 6, countNumber: data.deliveredOrder!);
        CustomTabListModel rejectedOrder = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', orderNo: 7, countNumber: data.rejectedOrder!);
        tabsList.add(newOrder);
        tabsList.add(preparingOrder);
        tabsList.add(readyOrder);
        tabsList.add(handOverOrder);
        tabsList.add(ongoingOrder);
        tabsList.add(deliveredOrder);
        tabsList.add(rejectedOrder);
        emit(state.copyWith(status: data.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty, orderList: data, tabList: tabsList, activeTab: 'new'));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrdersTabChangeEvent(OrdersTabChangeEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.changeTabs, activeTab: event.key));
      final String vendorId = await _orderRepository.getVendorId();
      OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize, page: state.currentPage, vendorId: vendorId, status: event.key);
      DioApiResponse response = await _orderRepository.getOrderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', countNumber: data.newOrders!);
        CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', countNumber: data.preparingOrders!);
        CustomTabListModel readyOrder = CustomTabListModel(label: 'Ready (##dynamic##)', key: 'ready', countNumber: data.readyOrder!);
        CustomTabListModel handOverOrder = CustomTabListModel(label: 'Pickd up (##dynamic##)', key: 'handover', countNumber: data.handOverOrder!);
        CustomTabListModel ongoingOrder = CustomTabListModel(label: 'Ongoing (##dynamic##)', key: 'ongoing', countNumber: data.ongoingOrder!);
        CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Delivered (##dynamic##)', key: 'delivered', countNumber: data.deliveredOrder!);
        CustomTabListModel rejectedOrder = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', countNumber: data.rejectedOrder!);
        tabsList.add(newOrder);
        tabsList.add(preparingOrder);
        tabsList.add(readyOrder);
        tabsList.add(handOverOrder);
        tabsList.add(ongoingOrder);
        tabsList.add(deliveredOrder);
        tabsList.add(rejectedOrder);
        emit(state.copyWith(status: data.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty, orderList: data, tabList: tabsList));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrdersPreparationTimeChangeEvent(OrdersPreparationTimeChangeEvent event, Emitter<OrdersState> emit) async {
    if (state.orderList.orders![event.orderIndex].preparationTime! == 5 && event.action == 'decrease') {
      state.orderList.orders![event.orderIndex].preparationTime = 5;
      emit(state.copyWith(orderList: state.orderList, status: OrdersStatus.success));
    } else if (event.action == 'decrease') {
      state.orderList.orders![event.orderIndex].preparationTime = state.orderList.orders![event.orderIndex].preparationTime! - 5;
      emit(state.copyWith(orderList: state.orderList, status: OrdersStatus.success));
    } else {
      state.orderList.orders![event.orderIndex].preparationTime = state.orderList.orders![event.orderIndex].preparationTime! + 5;
      emit(state.copyWith(orderList: state.orderList, status: OrdersStatus.success));
    }
  }

  FutureOr<void> _onOrdersAcceptNewOrderEvent(OrdersAcceptNewOrderEvent event, Emitter<OrdersState> emit) async {
    if (state.orderList.orders![event.orderIndex].instantOrder!) {
      try {
        emit(state.copyWith(status: OrdersStatus.orderChange, newOrderStatus: 'accept', orderChangeId: state.orderList.orders![event.orderIndex].id));
        final String vendorId = await _orderRepository.getVendorId();
        final int prepareTime = state.orderList.orders![event.orderIndex].preparationTime!;
        final String orderId = state.orderList.orders![event.orderIndex].id!;
        final String userId = state.orderList.orders![event.orderIndex].userInfo!.id!;
        PrepareOrderRequestModel param = PrepareOrderRequestModel(id: orderId, time: prepareTime, vendorId: vendorId, driverId: event.driverId, user: userId);
        DioApiResponse response = await _orderRepository.prepareOrder(param);
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
            emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty));
          } else {
            emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrdersStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    } else {
      try {
        emit(state.copyWith(status: OrdersStatus.orderChange, newOrderStatus: 'accept', orderChangeId: state.orderList.orders![event.orderIndex].id));
        final String vendorId = await _orderRepository.getVendorId();
        final String orderId = state.orderList.orders![event.orderIndex].id!;
        final String userId = state.orderList.orders![event.orderIndex].userInfo!.id!;
        AcceptScheduleOrderRequestModel param = AcceptScheduleOrderRequestModel(id: orderId, vendorId: vendorId, user: userId);
        DioApiResponse response = await _orderRepository.acceptScheduleOrder(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            state.orderList.orders![event.orderIndex].status = 'accepted';
            state.orderList.orders![event.orderIndex].statusName = 'Accepted';
            emit(state.copyWith(orderList: state.orderList, status: OrdersStatus.success));
          } else {
            emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrdersStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onOrdersRejectEvent(OrdersRejectEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.orderChange, newOrderStatus: 'reject', orderChangeId: state.orderList.orders![event.orderIndex].id));
      final String orderId = state.orderList.orders![event.orderIndex].id!;
      final String vendorId = await _orderRepository.getVendorId();
      RejectOrderRequestModel param = RejectOrderRequestModel(id: orderId, restaurant: vendorId, reason: event.reasonId);
      DioApiResponse response = await _orderRepository.rejectOrder(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          if (state.orderList.newOrders! == 1) {
            state.orderList.newOrders = 0;
          } else {
            state.orderList.newOrders = state.orderList.newOrders! - 1;
          }
          state.orderList.rejectedOrder = state.orderList.rejectedOrder! + 1;
          final int newTabIndex = state.tabList!.indexWhere((element) => element.key == 'new');
          final int rejectedTabIndex = state.tabList!.indexWhere((element) => element.key == 'rejected');
          if (newTabIndex != -1) {
            state.tabList![newTabIndex].label = "New (##dynamic##)";
            state.tabList![newTabIndex].countNumber = state.orderList.newOrders!;
          }
          if (rejectedTabIndex != -1) {
            state.tabList![rejectedTabIndex].label = "Rejected (##dynamic##)";
            state.tabList![rejectedTabIndex].countNumber = state.orderList.rejectedOrder!;
          }
          state.orderList.orders!.removeAt(event.orderIndex);
          emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty));
        } else {
          emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrdersAcceptScheduleOrderEvent(OrdersAcceptScheduleOrderEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.orderChange, newOrderStatus: 'prepareSchedule', orderChangeId: state.orderList.orders![event.orderIndex].id));
      final String vendorId = await _orderRepository.getVendorId();
      final int prepareTime = state.orderList.orders![event.orderIndex].preparationTime!;
      final String orderId = state.orderList.orders![event.orderIndex].id!;
      final String userId = state.orderList.orders![event.orderIndex].userInfo!.id!;
      PrepareOrderRequestModel param = PrepareOrderRequestModel(id: orderId, time: prepareTime, vendorId: vendorId, driverId: event.driverId, user: userId);
      DioApiResponse response = await _orderRepository.prepareOrder(param);
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
          emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty));
        } else {
          emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderReadyEvent(OrderReadyEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.orderChange, newOrderStatus: 'readyOrder', orderChangeId: state.orderList.orders![event.orderIndex].id));
      final String vendorId = await _orderRepository.getVendorId();
      final String orderId = state.orderList.orders![event.orderIndex].id!;
      final String userId = state.orderList.orders![event.orderIndex].userInfo!.id!;
      OrderReadyRequestModel param = OrderReadyRequestModel(id: orderId, vendorId: vendorId, user: userId);
      DioApiResponse response = await _orderRepository.orderReady(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          if (state.orderList.preparingOrders! == 1) {
            state.orderList.preparingOrders = 0;
          } else {
            state.orderList.preparingOrders = state.orderList.preparingOrders! - 1;
          }
          state.orderList.readyOrder = state.orderList.readyOrder! + 1;
          final int preparingIndex = state.tabList!.indexWhere((element) => element.key == 'preparing');
          final int readyOrderIndex = state.tabList!.indexWhere((element) => element.key == 'ready');
          if (preparingIndex != -1) {
            state.tabList![preparingIndex].label = "Preparing (##dynamic##)";
            state.tabList![preparingIndex].countNumber = state.orderList.preparingOrders!;
          }
          if (readyOrderIndex != -1) {
            state.tabList![readyOrderIndex].label = "Ready (##dynamic##)";
            state.tabList![readyOrderIndex].countNumber = state.orderList.readyOrder!;
          }
          state.orderList.orders!.removeAt(event.orderIndex);
          emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty));
        } else {
          emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderHandOverEvent(OrderHandOverEvent event, Emitter<OrdersState> emit) async {
    try {
      if (state.orderList.orders![event.orderIndex].orderTo! == 'homedelivery') {
        emit(state.copyWith(status: OrdersStatus.orderChange, newOrderStatus: 'handoverOrder', orderChangeId: state.orderList.orders![event.orderIndex].id));
        final String vendorId = await _orderRepository.getVendorId();
        final String orderId = state.orderList.orders![event.orderIndex].id!;
        final String userId = state.orderList.orders![event.orderIndex].userInfo!.id!;
        OrderHandoverToDriverRequestModel param = OrderHandoverToDriverRequestModel(id: orderId, vendorId: vendorId, user: userId);
        DioApiResponse response = await _orderRepository.orderHandoverToDriver(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            if (state.orderList.readyOrder! == 1) {
              state.orderList.readyOrder = 0;
            } else {
              state.orderList.readyOrder = state.orderList.readyOrder! - 1;
            }
            state.orderList.handOverOrder = state.orderList.handOverOrder! + 1;
            final int readyIndex = state.tabList!.indexWhere((element) => element.key == 'ready');
            final int handoverIndex = state.tabList!.indexWhere((element) => element.key == 'handover');
            if (readyIndex != -1) {
              state.tabList![readyIndex].label = "Ready (##dynamic##)";
              state.tabList![readyIndex].countNumber = state.orderList.readyOrder!;
            }
            if (handoverIndex != -1) {
              state.tabList![handoverIndex].label = "Pickd up (##dynamic##)";
              state.tabList![handoverIndex].countNumber = state.orderList.handOverOrder!;
            }
            state.orderList.orders!.removeAt(event.orderIndex);
            emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty));
          } else {
            emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrdersStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } else {
        emit(state.copyWith(status: OrdersStatus.orderChange, newOrderStatus: 'handoverOrder', orderChangeId: state.orderList.orders![event.orderIndex].id));
        final String vendorId = await _orderRepository.getVendorId();
        final String orderId = state.orderList.orders![event.orderIndex].id!;
        final String userId = state.orderList.orders![event.orderIndex].userInfo!.id!;
        OrderHandoverToCustomerRequestModel param = OrderHandoverToCustomerRequestModel(id: orderId, vendorId: vendorId, user: userId);
        DioApiResponse response = await _orderRepository.orderHandoverToCustomer(param);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (initialResponse.success!) {
            if (state.orderList.readyOrder! == 1) {
              state.orderList.readyOrder = 0;
            } else {
              state.orderList.readyOrder = state.orderList.readyOrder! - 1;
            }
            state.orderList.deliveredOrder = state.orderList.deliveredOrder! + 1;
            final int readyIndex = state.tabList!.indexWhere((element) => element.key == 'ready');
            final int deliverOrderIndex = state.tabList!.indexWhere((element) => element.key == 'delivered');
            if (readyIndex != -1) {
              state.tabList![readyIndex].label = "Ready (##dynamic##)";
              state.tabList![readyIndex].countNumber = state.orderList.readyOrder!;
            }
            if (deliverOrderIndex != -1) {
              state.tabList![deliverOrderIndex].label = "Delivered (##dynamic##)";
              state.tabList![deliverOrderIndex].countNumber = state.orderList.deliveredOrder!;
            }
            state.orderList.orders!.removeAt(event.orderIndex);
            emit(state.copyWith(orderList: state.orderList, tabList: state.tabList, status: state.orderList.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty));
          } else {
            emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrdersStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderLoadMoreEvent(OrderLoadMoreEvent event, Emitter<OrdersState> emit) async {
    if (state.orderList.orders!.length < state.orderList.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _orderRepository.getVendorId();
        OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize * 2, page: state.currentPage, vendorId: vendorId, status: state.activeTab);
        DioApiResponse response = await _orderRepository.getOrderList(param);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
          List<CustomTabListModel> tabsList = <CustomTabListModel>[];
          tabsList.clear();
          CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', orderNo: 1, countNumber: data.newOrders!);
          CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', orderNo: 2, countNumber: data.preparingOrders!);
          CustomTabListModel readyOrder = CustomTabListModel(label: 'Ready (##dynamic##)', key: 'ready', orderNo: 3, countNumber: data.readyOrder!);
          CustomTabListModel handOverOrder = CustomTabListModel(label: 'Pickd up (##dynamic##)', key: 'handover', orderNo: 4, countNumber: data.handOverOrder!);
          CustomTabListModel ongoingOrder = CustomTabListModel(label: 'Ongoing (##dynamic##)', key: 'ongoing', orderNo: 5, countNumber: data.ongoingOrder!);
          CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Delivered (##dynamic##)', key: 'delivered', orderNo: 6, countNumber: data.deliveredOrder!);
          CustomTabListModel rejectedOrder = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', orderNo: 7, countNumber: data.rejectedOrder!);
          tabsList.add(newOrder);
          tabsList.add(preparingOrder);
          tabsList.add(readyOrder);
          tabsList.add(handOverOrder);
          tabsList.add(ongoingOrder);
          tabsList.add(deliveredOrder);
          tabsList.add(rejectedOrder);
          emit(state.copyWith(status: data.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty, orderList: data, tabList: tabsList, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: OrdersStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), loadMore: false, extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: OrdersStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onOrderPullRefreshEvent(OrderPullRefreshEvent event, Emitter<OrdersState> emit) async {
    try {
      final bool haveOwnDriver = await _orderRepository.haveOwnDriver();
      emit(state.copyWith(status: OrdersStatus.loading, ownDriver: haveOwnDriver, pageSize: ApiRequestService.pageSize));
      final String vendorId = await _orderRepository.getVendorId();
      OrderListRequestModel param = OrderListRequestModel(limit: state.pageSize, page: state.currentPage, vendorId: vendorId, status: state.activeTab);
      DioApiResponse response = await _orderRepository.getOrderList(param);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OrderListModel data = OrderListModel.fromJson(myMap, locale.toString());
        List<CustomTabListModel> tabsList = <CustomTabListModel>[];
        tabsList.clear();
        CustomTabListModel newOrder = CustomTabListModel(label: 'New (##dynamic##)', key: 'new', orderNo: 1, countNumber: data.newOrders!);
        CustomTabListModel preparingOrder = CustomTabListModel(label: 'Preparing (##dynamic##)', key: 'preparing', orderNo: 2, countNumber: data.preparingOrders!);
        CustomTabListModel readyOrder = CustomTabListModel(label: 'Ready (##dynamic##)', key: 'ready', orderNo: 3, countNumber: data.readyOrder!);
        CustomTabListModel handOverOrder = CustomTabListModel(label: 'Pickd up (##dynamic##)', key: 'handover', orderNo: 4, countNumber: data.handOverOrder!);
        CustomTabListModel ongoingOrder = CustomTabListModel(label: 'Ongoing (##dynamic##)', key: 'ongoing', orderNo: 5, countNumber: data.ongoingOrder!);
        CustomTabListModel deliveredOrder = CustomTabListModel(label: 'Delivered (##dynamic##)', key: 'delivered', orderNo: 6, countNumber: data.deliveredOrder!);
        CustomTabListModel rejectedOrder = CustomTabListModel(label: 'Rejected (##dynamic##)', key: 'rejected', orderNo: 7, countNumber: data.rejectedOrder!);
        tabsList.add(newOrder);
        tabsList.add(preparingOrder);
        tabsList.add(readyOrder);
        tabsList.add(handOverOrder);
        tabsList.add(ongoingOrder);
        tabsList.add(deliveredOrder);
        tabsList.add(rejectedOrder);
        emit(state.copyWith(status: data.orders!.isNotEmpty ? OrdersStatus.success : OrdersStatus.empty, orderList: data, tabList: tabsList));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrdersStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderCloseTemporaryEvent(OrderCloseTemporaryEvent event, Emitter<OrdersState> emit) async {
    try {
      state.orderList.restaurantInfo!.temporaryClosed = true;
      emit(state.copyWith(orderList: state.orderList));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.temporaryCloseRestaurant(vendorId);
      if (response.errorType == NetErrorType.none) {
      } else {
        state.orderList.restaurantInfo!.temporaryClosed = false;
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.customError, orderList: state.orderList, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      state.orderList.restaurantInfo!.temporaryClosed = false;
      emit(state.copyWith(status: OrdersStatus.customError, orderList: state.orderList, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onReOpenRestaurantEvent(ReOpenRestaurantEvent event, Emitter<OrdersState> emit) async {
    try {
      state.orderList.restaurantInfo!.temporaryClosed = false;
      emit(state.copyWith(orderList: state.orderList));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.reOpenTemporaryRestaurant(vendorId);
      if (response.errorType == NetErrorType.none) {
      } else {
        state.orderList.restaurantInfo!.temporaryClosed = true;
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: OrdersStatus.customError, orderList: state.orderList, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      state.orderList.restaurantInfo!.temporaryClosed = true;
      emit(state.copyWith(status: OrdersStatus.customError, orderList: state.orderList, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
