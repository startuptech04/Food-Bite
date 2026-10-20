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
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/table_order_detail_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/table_order_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'table_order_detail_event.dart';
part 'table_order_detail_state.dart';

class TableOrderDetailBloc extends Bloc<TableOrderDetailEvent, TableOrderDetailState> {
  final TableOrderRepository _tableOrderRepository = TableOrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  TableOrderDetailBloc() : super(TableOrderDetailState(model: TableOrderDetailModel(success: false, locale: ''))) {
    on<TableOrderDetailInitialEvent>(_onTableOrderDetailInitialEvent);
  }

  FutureOr<void> _onTableOrderDetailInitialEvent(TableOrderDetailInitialEvent event, Emitter<TableOrderDetailState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "table_order_detail"}, 'table_order_detail_screen', 'table_order_detail_screen');
      emit(state.copyWith(status: TableOrderDetailStatus.loading, orderId: event.orderId));
      DioApiResponse response = await _tableOrderRepository.tableOrderDetail(event.orderId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (initialResponse.success!) {
          TableOrderDetailModel data = TableOrderDetailModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: TableOrderDetailStatus.success, model: data));
        } else {
          emit(state.copyWith(status: TableOrderDetailStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: TableOrderDetailStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: TableOrderDetailStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
