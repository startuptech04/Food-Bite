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
import 'package:vendor/app/core/models/completed_table_order_list_model.dart';
import 'package:vendor/app/core/models/custom_tabs_list_model.dart';
import 'package:vendor/app/core/models/ongoing_table_order_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/table_order_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_order_list_event.dart';
part 'table_order_list_state.dart';

class TableOrderListBloc extends Bloc<TableOrderListEvent, TableOrderListState> {
  final TableOrderRepository _tableOrderRepository = TableOrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TableOrderListBloc()
    : super(
        TableOrderListState(
          ongoingOrder: OngoingTableOrderModel(tables: [], success: false),
          completedOrders: CompletedTableOrderListModel(orders: [], success: false, locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<TableOrderListInitialEvent>(_onTableOrderListInitialEvent);
    on<TableOrderListTabChangeEvent>(_onTableOrderListTabChangeEvent);
    on<TableOrderListRefreshTableEvent>(_onTableOrderListRefreshTableEvent);
    on<TableOrderListFetchCompletedOrderEvent>(_onTableOrderListFetchCompletedOrderEvent);
    on<TableOrderListFetchMoreCompletedOrderEvent>(_onTableOrderListFetchMoreCompletedOrderEvent);
    on<TableOrderListPullRefreshEvent>(_onTableOrderListPullRefreshEvent);
  }

  FutureOr<void> _onTableOrderListInitialEvent(TableOrderListInitialEvent event, Emitter<TableOrderListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "table_order_list"}, 'table_order_list_screen', 'table_order_list_screen');
      List<CustomTabListModel> tabsList = <CustomTabListModel>[];
      tabsList.clear();
      CustomTabListModel ongoingOrder = CustomTabListModel(label: 'dd_ongoing_orders', key: 'ongoing', orderNo: 1, countNumber: 0);
      CustomTabListModel completedOrder = CustomTabListModel(label: 'dd_completed_orders', key: 'completed', orderNo: 2, countNumber: 0);
      tabsList.add(ongoingOrder);
      tabsList.add(completedOrder);
      emit(state.copyWith(status: TableOrderListStatus.loading, tabList: tabsList, activeTab: 'ongoing'));
      DioApiResponse response = await _tableOrderRepository.onGoingTableOrder();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OngoingTableOrderModel data = OngoingTableOrderModel.fromJson(myMap);
        emit(state.copyWith(ongoingOrder: data, status: data.tables!.isNotEmpty ? TableOrderListStatus.success : TableOrderListStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderListTabChangeEvent(TableOrderListTabChangeEvent event, Emitter<TableOrderListState> emit) async {
    emit(state.copyWith(activeTab: event.key));
    if (event.key == 'ongoing') {
      add(TableOrderListRefreshTableEvent());
    } else {
      add(TableOrderListFetchCompletedOrderEvent());
    }
  }

  FutureOr<void> _onTableOrderListRefreshTableEvent(TableOrderListRefreshTableEvent event, Emitter<TableOrderListState> emit) async {
    try {
      emit(state.copyWith(status: TableOrderListStatus.loading, activeTab: 'ongoing'));
      DioApiResponse response = await _tableOrderRepository.onGoingTableOrder();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        OngoingTableOrderModel data = OngoingTableOrderModel.fromJson(myMap);
        emit(state.copyWith(ongoingOrder: data, status: data.tables!.isNotEmpty ? TableOrderListStatus.success : TableOrderListStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderListFetchCompletedOrderEvent(TableOrderListFetchCompletedOrderEvent event, Emitter<TableOrderListState> emit) async {
    try {
      emit(state.copyWith(status: TableOrderListStatus.loading));
      DioApiResponse response = await _tableOrderRepository.completedTableOrderList(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        CompletedTableOrderListModel data = CompletedTableOrderListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(completedOrders: data, status: data.orders!.isNotEmpty ? TableOrderListStatus.success : TableOrderListStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableOrderListFetchMoreCompletedOrderEvent(TableOrderListFetchMoreCompletedOrderEvent event, Emitter<TableOrderListState> emit) async {
    if (state.completedOrders.orders!.length < state.completedOrders.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        DioApiResponse response = await _tableOrderRepository.completedTableOrderList(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          CompletedTableOrderListModel data = CompletedTableOrderListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: data.orders!.isNotEmpty ? TableOrderListStatus.success : TableOrderListStatus.empty, completedOrders: data, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: TableOrderListStatus.customError, statusCode: data.code, loadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: TableOrderListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onTableOrderListPullRefreshEvent(TableOrderListPullRefreshEvent event, Emitter<TableOrderListState> emit) async {
    if (state.activeTab == 'ongoing') {
      add(TableOrderListRefreshTableEvent());
    } else {
      add(TableOrderListFetchCompletedOrderEvent());
    }
  }
}
