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
import 'package:vendor/app/core/models/pos_order_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/pos_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'pos_order_list_event.dart';
part 'pos_order_list_state.dart';

class PosOrderListBloc extends Bloc<PosOrderListEvent, PosOrderListState> {
  final PosRepository _posRepository = PosRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PosOrderListBloc()
    : super(
        PosOrderListState(
          model: PosOrderListModel(orders: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<PosOrderListInitialEvent>(_onPosOrderListInitialEvent);
    on<PosOrderListPullRefreshEvent>(_onPosOrderListPullRefreshEvent);
    on<PosOrderListScrollMoreEvent>(_onPosOrderListScrollMoreEvent);
  }

  FutureOr<void> _onPosOrderListInitialEvent(PosOrderListInitialEvent event, Emitter<PosOrderListState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "pos_order_list"}, 'pos_order_list_screen', 'pos_order_list_screen');
      emit(state.copyWith(status: PosOrderListStatus.loading));
      DioApiResponse response = await _posRepository.posOrderList(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PosOrderListModel data = PosOrderListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.orders!.isNotEmpty ? PosOrderListStatus.success : PosOrderListStatus.empty, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PosOrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PosOrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPosOrderListPullRefreshEvent(PosOrderListPullRefreshEvent event, Emitter<PosOrderListState> emit) async {
    try {
      emit(state.copyWith(status: PosOrderListStatus.loading, pageSize: ApiRequestService.pageSize));
      DioApiResponse response = await _posRepository.posOrderList(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PosOrderListModel data = PosOrderListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.orders!.isNotEmpty ? PosOrderListStatus.success : PosOrderListStatus.empty, model: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PosOrderListStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PosOrderListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPosOrderListScrollMoreEvent(PosOrderListScrollMoreEvent event, Emitter<PosOrderListState> emit) async {
    if (state.model.orders!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        DioApiResponse response = await _posRepository.posOrderList(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          PosOrderListModel data = PosOrderListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: data.orders!.isNotEmpty ? PosOrderListStatus.success : PosOrderListStatus.empty, model: data, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: PosOrderListStatus.customError, statusCode: data.code, loadMore: false, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: PosOrderListStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
