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
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/submitted_cash_in_hand_history_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'cash_in_hand_submitted_cash_history_event.dart';
part 'cash_in_hand_submitted_cash_history_state.dart';

class CashInHandSubmittedCashHistoryBloc extends Bloc<CashInHandSubmittedCashHistoryEvent, CashInHandSubmittedCashHistoryState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  CashInHandSubmittedCashHistoryBloc()
    : super(
        CashInHandSubmittedCashHistoryState(
          model: SubmittedCashInHandHistoryListModel(collected: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<CashInHandSubmittedCashHistoryInitialEvent>(_onCashInHandSubmittedCashHistoryInitialEvent);
    on<CashInHandSubmittedCashHistoryScrollMoreEvent>(_onCashInHandSubmittedCashHistoryScrollMoreEvent);
  }

  FutureOr<void> _onCashInHandSubmittedCashHistoryInitialEvent(CashInHandSubmittedCashHistoryInitialEvent event, Emitter<CashInHandSubmittedCashHistoryState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "submitted_cash_history"}, 'submitted_cash_history_screen', 'submitted_cash_history_screen');
      emit(state.copyWith(status: CashInHandSubmittedCashHistoryStatus.loading));
      DioApiResponse response = await _walletRepository.getCollectedCashInHandHistory(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        SubmittedCashInHandHistoryListModel data = SubmittedCashInHandHistoryListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.collected!.isEmpty ? CashInHandSubmittedCashHistoryStatus.empty : CashInHandSubmittedCashHistoryStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CashInHandSubmittedCashHistoryStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CashInHandSubmittedCashHistoryStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCashInHandSubmittedCashHistoryScrollMoreEvent(CashInHandSubmittedCashHistoryScrollMoreEvent event, Emitter<CashInHandSubmittedCashHistoryState> emit) async {
    if (state.model.collected!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        DioApiResponse response = await _walletRepository.getCollectedCashInHandHistory(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          SubmittedCashInHandHistoryListModel data = SubmittedCashInHandHistoryListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, loadMore: false, pageSize: state.pageSize * 2, status: data.collected!.isEmpty ? CashInHandSubmittedCashHistoryStatus.empty : CashInHandSubmittedCashHistoryStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: CashInHandSubmittedCashHistoryStatus.customError, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: CashInHandSubmittedCashHistoryStatus.customError, loadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
