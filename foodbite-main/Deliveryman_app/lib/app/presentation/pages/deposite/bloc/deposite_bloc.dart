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
import 'package:driver/app/core/models/cash_in_hand_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:driver/app/core/repositories/wallet_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'deposite_event.dart';
part 'deposite_state.dart';

class DepositeBloc extends Bloc<DepositeEvent, DepositeState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AuthRepository _authRepository = AuthRepository();
  DepositeBloc()
    : super(
        DepositeState(
          model: CashInHandModel(cashInHandAmount: 0, success: false, history: [], collected: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<DepositeInitialEvent>(_onDepositeInitialEvent);
    on<DepositeToggleEvent>(_onDepositeToggleEvent);
    on<DepositeHistoryLoadMoreEvent>(_onDepositeHistoryLoadMoreEvent);
    on<DepositeCollectedCashLoadMoreEvent>(_onDepositeCollectedCashLoadMoreEvent);
  }

  FutureOr<void> _onDepositeInitialEvent(DepositeInitialEvent event, Emitter<DepositeState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "deposite_cash"}, 'deposite_cash_screen', 'deposite_cash_screen');
      emit(state.copyWith(status: DepositeStatus.loading, toggleTransaction: 'in-hand'));
      DioApiResponse response = await _walletRepository.depositeDetail(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        CashInHandModel data = CashInHandModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: DepositeStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DepositeStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DepositeStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDepositeToggleEvent(DepositeToggleEvent event, Emitter<DepositeState> emit) async {
    emit(state.copyWith(toggleTransaction: event.toggle, status: DepositeStatus.success));
  }

  FutureOr<void> _onDepositeHistoryLoadMoreEvent(DepositeHistoryLoadMoreEvent event, Emitter<DepositeState> emit) async {
    if (state.model.history!.length < state.model.totalHistoryResults!) {
      try {
        emit(state.copyWith(loadMoreHistory: true));
        DioApiResponse response = await _walletRepository.depositeDetail(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _authRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          CashInHandModel data = CashInHandModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, loadMoreHistory: false, pageSize: state.pageSize * 2, status: DepositeStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DepositeStatus.failure, loadMoreHistory: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DepositeStatus.failure, statusCode: 0, loadMoreHistory: false, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onDepositeCollectedCashLoadMoreEvent(DepositeCollectedCashLoadMoreEvent event, Emitter<DepositeState> emit) async {
    if (state.model.collected!.length < state.model.totalCollectedResults!) {
      try {
        emit(state.copyWith(loadMoreCollected: true));
        DioApiResponse response = await _walletRepository.depositeDetail(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _authRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          CashInHandModel data = CashInHandModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, loadMoreCollected: false, pageSize: state.pageSize * 2, status: DepositeStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: DepositeStatus.failure, loadMoreCollected: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: DepositeStatus.failure, statusCode: 0, loadMoreCollected: false, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }
}
