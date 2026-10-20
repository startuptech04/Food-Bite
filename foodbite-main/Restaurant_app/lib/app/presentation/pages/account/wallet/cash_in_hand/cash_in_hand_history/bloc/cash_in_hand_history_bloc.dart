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
import 'package:vendor/app/core/models/cash_in_hand_history_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'cash_in_hand_history_event.dart';
part 'cash_in_hand_history_state.dart';

class CashInHandHistoryBloc extends Bloc<CashInHandHistoryEvent, CashInHandHistoryState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CashInHandHistoryBloc()
    : super(
        CashInHandHistoryState(
          model: CashInHandHistoryListModel(history: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<CashInHandHistoryInitialEvent>(_onCashInHandHistoryInitialEvent);
    on<CashInHandHistoryScrollMoreEvent>(_onCashInHandHistoryScrollMoreEvent);
  }

  FutureOr<void> _onCashInHandHistoryInitialEvent(CashInHandHistoryInitialEvent event, Emitter<CashInHandHistoryState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "cash_in_hand_history"}, 'cash_in_hand_history_screen', 'cash_in_hand_history_screen');
      emit(state.copyWith(status: CashInHandHistoryStatus.loading));
      DioApiResponse response = await _walletRepository.getCashInHandHistory(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        CashInHandHistoryListModel data = CashInHandHistoryListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.history!.isEmpty ? CashInHandHistoryStatus.empty : CashInHandHistoryStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CashInHandHistoryStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CashInHandHistoryStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCashInHandHistoryScrollMoreEvent(CashInHandHistoryScrollMoreEvent event, Emitter<CashInHandHistoryState> emit) async {
    if (state.model.history!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        DioApiResponse response = await _walletRepository.getCashInHandHistory(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          CashInHandHistoryListModel data = CashInHandHistoryListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, loadMore: false, pageSize: state.pageSize * 2, status: data.history!.isEmpty ? CashInHandHistoryStatus.empty : CashInHandHistoryStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: CashInHandHistoryStatus.customError, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: CashInHandHistoryStatus.customError, loadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
