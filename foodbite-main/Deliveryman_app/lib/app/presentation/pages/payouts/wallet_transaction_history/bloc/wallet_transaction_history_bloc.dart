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
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/models/wallet_transaction_list_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/wallet_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'wallet_transaction_history_event.dart';
part 'wallet_transaction_history_state.dart';

class WalletTransactionHistoryBloc extends Bloc<WalletTransactionHistoryEvent, WalletTransactionHistoryState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AuthRepository _authRepository = AuthRepository();
  WalletTransactionHistoryBloc()
    : super(
        WalletTransactionHistoryState(
          model: WalletTransactionListModel(transaction: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<WalletTransactionHistoryInitialEvent>(_onWalletTransactionHistoryInitialEvent);
    on<WalletTransactionHistoryToggleTransactionEvent>(_onWalletTransactionHistoryToggleTransactionEvent);
    on<WalletTransactionHistoryScrollMoreTransactionEvent>(_onWalletTransactionHistoryScrollMoreTransactionEvent);
  }

  FutureOr<void> _onWalletTransactionHistoryInitialEvent(WalletTransactionHistoryInitialEvent event, Emitter<WalletTransactionHistoryState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "wallet_transaction_history"}, 'wallet_transaction_history_screen', 'wallet_transaction_history_screen');
      emit(state.copyWith(status: WalletTransactionHistoryStatus.loading));
      DioApiResponse response = await _walletRepository.getWalletTransaction(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        WalletTransactionListModel data = WalletTransactionListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.transaction!.isEmpty ? WalletTransactionHistoryStatus.empty : WalletTransactionHistoryStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: WalletTransactionHistoryStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: WalletTransactionHistoryStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onWalletTransactionHistoryToggleTransactionEvent(WalletTransactionHistoryToggleTransactionEvent event, Emitter<WalletTransactionHistoryState> emit) async {
    if (state.toggleTransaction == event.transaction) {
      emit(state.copyWith(toggleTransaction: ''));
    } else {
      emit(state.copyWith(toggleTransaction: event.transaction));
    }
  }

  FutureOr<void> _onWalletTransactionHistoryScrollMoreTransactionEvent(WalletTransactionHistoryScrollMoreTransactionEvent event, Emitter<WalletTransactionHistoryState> emit) async {
    if (state.model.transaction!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        DioApiResponse response = await _walletRepository.getWalletTransaction(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _authRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          WalletTransactionListModel data = WalletTransactionListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, loadMore: false, pageSize: state.pageSize * 2, status: data.transaction!.isEmpty ? WalletTransactionHistoryStatus.empty : WalletTransactionHistoryStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: WalletTransactionHistoryStatus.customError, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: WalletTransactionHistoryStatus.customError, loadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
