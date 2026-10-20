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
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/models/restaurant_table_list_model.dart';
import 'package:waiter/app/core/models/server_error_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/core/repositories/pos_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_order_event.dart';
part 'table_order_state.dart';

class TableOrderBloc extends Bloc<TableOrderEvent, TableOrderState> {
  final PosRepository _posRepository = PosRepository();
  final AuthRepository _authRepository = AuthRepository();
  TableOrderBloc() : super(TableOrderState(model: RestaurantTableListModel(tables: [], success: false))) {
    on<TableOrderInitialEvent>(_onTableOrderInitialEvent);
  }

  FutureOr<void> _onTableOrderInitialEvent(TableOrderInitialEvent event, Emitter<TableOrderState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "table_order"}, 'table_order_screen', 'table_order_screen');
      emit(state.copyWith(status: TableOrderStatus.loading));
      DioApiResponse response = await _posRepository.getTableList();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        RestaurantTableListModel tables = RestaurantTableListModel.fromJson(myMap);
        emit(state.copyWith(model: tables, status: tables.tables!.isEmpty ? TableOrderStatus.empty : TableOrderStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
