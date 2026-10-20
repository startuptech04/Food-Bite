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
import 'package:vendor/app/core/models/pos_and_table_order_commission_history_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'pos_and_table_order_commission_event.dart';
part 'pos_and_table_order_commission_state.dart';

class PosAndTableOrderCommissionBloc extends Bloc<PosAndTableOrderCommissionEvent, PosAndTableOrderCommissionState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PosAndTableOrderCommissionBloc()
    : super(
        PosAndTableOrderCommissionState(
          model: PosAndTableOrderCommissionHistoryListModel(history: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<PosAndTableOrderCommissionInitialEvent>(_onPosAndTableOrderCommissionInitialEvent);
    on<PosAndTableOrderCommissionLoadMoreEvent>(_onPosAndTableOrderCommissionLoadMoreEvent);
  }

  FutureOr<void> _onPosAndTableOrderCommissionInitialEvent(PosAndTableOrderCommissionInitialEvent event, Emitter<PosAndTableOrderCommissionState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "pos_or_table_order_commission"}, 'pos_or_table_order_commission_screen', 'pos_or_table_order_commission_screen');
      emit(state.copyWith(status: PosAndTableOrderCommissionStatus.loading));
      DioApiResponse response = await _walletRepository.getPosAndTableOrderCommissionHistory(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PosAndTableOrderCommissionHistoryListModel data = PosAndTableOrderCommissionHistoryListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.history!.isEmpty ? PosAndTableOrderCommissionStatus.empty : PosAndTableOrderCommissionStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PosAndTableOrderCommissionStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PosAndTableOrderCommissionStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPosAndTableOrderCommissionLoadMoreEvent(PosAndTableOrderCommissionLoadMoreEvent event, Emitter<PosAndTableOrderCommissionState> emit) async {}
}
