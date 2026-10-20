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
import 'package:vendor/app/core/models/withdrawal_history_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'wallet_withdrawal_history_event.dart';
part 'wallet_withdrawal_history_state.dart';

class WalletWithdrawalHistoryBloc extends Bloc<WalletWithdrawalHistoryEvent, WalletWithdrawalHistoryState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  WalletWithdrawalHistoryBloc()
    : super(
        WalletWithdrawalHistoryState(
          model: WithdrawalHistoryModel(results: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<WalletWithdrawalHistoryInitialEvent>(_onWalletWithdrawalHistoryInitialEvent);
    on<WalletWithdrawalHistoryToggleEvent>(_onWalletWithdrawalHistoryToggleEvent);
    on<WalletWithdrawalHistoryScrollMoreEvent>(_onWalletWithdrawalHistoryScrollMoreEvent);
  }

  FutureOr<void> _onWalletWithdrawalHistoryInitialEvent(WalletWithdrawalHistoryInitialEvent event, Emitter<WalletWithdrawalHistoryState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "wallet_withdrawal_history"}, 'wallet_withdrawal_history_screen', 'wallet_withdrawal_history_screen');
      emit(state.copyWith(status: WalletWithdrawalHistoryStatus.loading));
      DioApiResponse response = await _walletRepository.withdrawalHistory(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        WithdrawalHistoryModel data = WithdrawalHistoryModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.results!.isEmpty ? WalletWithdrawalHistoryStatus.empty : WalletWithdrawalHistoryStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: WalletWithdrawalHistoryStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: WalletWithdrawalHistoryStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onWalletWithdrawalHistoryToggleEvent(WalletWithdrawalHistoryToggleEvent event, Emitter<WalletWithdrawalHistoryState> emit) async {
    if (state.toggleTransaction == event.status) {
      emit(state.copyWith(toggleTransaction: ''));
    } else {
      emit(state.copyWith(toggleTransaction: event.status));
    }
  }

  FutureOr<void> _onWalletWithdrawalHistoryScrollMoreEvent(WalletWithdrawalHistoryScrollMoreEvent event, Emitter<WalletWithdrawalHistoryState> emit) async {
    if (state.model.results!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        DioApiResponse response = await _walletRepository.withdrawalHistory(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          WithdrawalHistoryModel data = WithdrawalHistoryModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, loadMore: false, pageSize: state.pageSize * 2, status: data.results!.isEmpty ? WalletWithdrawalHistoryStatus.empty : WalletWithdrawalHistoryStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: WalletWithdrawalHistoryStatus.customError, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: WalletWithdrawalHistoryStatus.customError, loadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
