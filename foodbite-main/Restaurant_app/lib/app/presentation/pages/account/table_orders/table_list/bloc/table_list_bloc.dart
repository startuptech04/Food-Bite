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
import 'package:vendor/app/core/models/request/update_restaurant_table_status_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/table_list_response_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/table_order_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_list_event.dart';
part 'table_list_state.dart';

class TableListBloc extends Bloc<TableListEvent, TableListState> {
  final TableOrderRepository _tableOrderRepository = TableOrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TableListBloc()
    : super(
        TableListState(
          model: TableListResponseModel(results: []),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<TableListInitialEvent>(_onTableListInitialEvent);
    on<TableListLoadMoreEvent>(_onTableListLoadMoreEvent);
    on<TableListChangeStatusEvent>(_onTableListChangeStatusEvent);
    on<TableListDeleteTableEvent>(_onTableListDeleteTableEvent);
  }

  FutureOr<void> _onTableListInitialEvent(TableListInitialEvent event, Emitter<TableListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "table_list"}, 'table_list_screen', 'table_list_screen');
      emit(state.copyWith(status: TableListStatus.loading));
      final String vendorId = await _tableOrderRepository.getVendorId();
      DioApiResponse response = await _tableOrderRepository.getTableList(vendorId, state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        TableListResponseModel tables = TableListResponseModel.fromJson(myMap);
        emit(state.copyWith(model: tables, status: tables.results!.isEmpty ? TableListStatus.empty : TableListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableListLoadMoreEvent(TableListLoadMoreEvent event, Emitter<TableListState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        final String vendorId = await _tableOrderRepository.getVendorId();
        DioApiResponse response = await _tableOrderRepository.getTableList(vendorId, state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          TableListResponseModel tables = TableListResponseModel.fromJson(myMap);
          emit(state.copyWith(model: tables, status: tables.results!.isEmpty ? TableListStatus.empty : TableListStatus.success, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: TableListStatus.failure, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: TableListStatus.failure, statusCode: 0, loadMore: false, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onTableListChangeStatusEvent(TableListChangeStatusEvent event, Emitter<TableListState> emit) async {
    try {
      UpdateRestaurantTableStatusRequestModel param = UpdateRestaurantTableStatusRequestModel(status: !state.model.results![event.index].status!);
      DioApiResponse response = await _tableOrderRepository.updateRestaurantTableStatus(state.model.results![event.index].id!, param);
      if (response.errorType == NetErrorType.none) {
        state.model.results![event.index].status = !state.model.results![event.index].status!;
        emit(state.copyWith(status: TableListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableListStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onTableListDeleteTableEvent(TableListDeleteTableEvent event, Emitter<TableListState> emit) async {
    try {
      DioApiResponse response = await _tableOrderRepository.deleteRestaurantTable(state.model.results![event.index].id!);
      if (response.errorType == NetErrorType.none) {
        state.model.results!.removeAt(event.index);
        emit(state.copyWith(model: state.model, status: TableListStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableListStatus.customError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
