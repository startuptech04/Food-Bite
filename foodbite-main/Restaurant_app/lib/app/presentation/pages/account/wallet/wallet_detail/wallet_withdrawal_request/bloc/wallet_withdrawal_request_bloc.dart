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
import 'package:vendor/app/core/models/request/withdrawal_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/models/wallet_withdrawal_detail_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'wallet_withdrawal_request_event.dart';
part 'wallet_withdrawal_request_state.dart';

class WalletWithdrawalRequestBloc extends Bloc<WalletWithdrawalRequestEvent, WalletWithdrawalRequestState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  WalletWithdrawalRequestBloc()
    : super(
        WalletWithdrawalRequestState(
          model: WalletWithdrawalDetailModel(locale: ''),
          selectedMethod: WalletPayoutMethodConfigModel(locale: ''),
        ),
      ) {
    on<WalletWithdrawalRequestInitialEvent>(_onWalletWithdrawalRequestInitialEvent);
    on<WalletWithdrawalDetailMethodChangeEvent>(_onWalletWithdrawalDetailMethodChangeEvent);
    on<WalletWithdrawalDetailAmountChangeEvent>(_onWalletWithdrawalDetailAmountChangeEvent);
    on<WalletWithdrawalDetailSubmitEvent>(_onWalletWithdrawalDetailSubmitEvent);
  }

  FutureOr<void> _onWalletWithdrawalRequestInitialEvent(WalletWithdrawalRequestInitialEvent event, Emitter<WalletWithdrawalRequestState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "wallet_withdrawal_request"}, 'wallet_withdrawal_request_screen', 'wallet_withdrawal_request_screen');
      emit(state.copyWith(status: WalletWithdrawalRequestStatus.loading));
      DioApiResponse response = await _walletRepository.withdrawalDetail();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        WalletWithdrawalDetailModel data = WalletWithdrawalDetailModel.fromJson(myMap, locale.toString());
        WalletPayoutMethodConfigModel firstMethod = WalletPayoutMethodConfigModel(locale: locale.toString());
        List<PayoutFormElementConfigModel> formElementList = <PayoutFormElementConfigModel>[];
        formElementList.clear();
        if (data.methods!.isNotEmpty) {
          firstMethod = data.methods!.first;
          formElementList = data.methods!.first.formElement!;
        }
        emit(state.copyWith(model: data, selectedMethod: firstMethod, formElementList: formElementList, status: WalletWithdrawalRequestStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: WalletWithdrawalRequestStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: WalletWithdrawalRequestStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onWalletWithdrawalDetailMethodChangeEvent(WalletWithdrawalDetailMethodChangeEvent event, Emitter<WalletWithdrawalRequestState> emit) async {
    try {
      emit(state.copyWith(selectedMethod: event.method, formElementList: event.method.formElement!, status: WalletWithdrawalRequestStatus.success));
    } catch (e, stacktrace) {
      emit(state.copyWith(status: WalletWithdrawalRequestStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onWalletWithdrawalDetailAmountChangeEvent(WalletWithdrawalDetailAmountChangeEvent event, Emitter<WalletWithdrawalRequestState> emit) async {
    emit(state.copyWith(amount: event.amount, status: WalletWithdrawalRequestStatus.success));
  }

  FutureOr<void> _onWalletWithdrawalDetailSubmitEvent(WalletWithdrawalDetailSubmitEvent event, Emitter<WalletWithdrawalRequestState> emit) async {
    try {
      bool isValidNonZeroNumber(String value) {
        final num? number = num.tryParse(value.trim());
        return number != null && number != 0;
      }

      if (state.amount.isNotEmpty && isValidNonZeroNumber(state.amount)) {
        emit(state.copyWith(isSubmitted: true, status: WalletWithdrawalRequestStatus.success));
        final double amount = double.parse(state.amount);
        if (amount <= state.model.walletInfo!.balance!) {
          emit(state.copyWith(status: WalletWithdrawalRequestStatus.submit));
          WithdrawalRequestModel param = WithdrawalRequestModel(
            restaurant: await _walletRepository.getVendorId(),
            restaurantPayoutMethod: state.selectedMethod.id!,
            withdrawalMethod: state.selectedMethod.method!.id!,
            amount: amount,
          );
          DioApiResponse response = await _walletRepository.withdrawalRequest(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: WalletWithdrawalRequestStatus.submitSuccess, amount: ''));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: WalletWithdrawalRequestStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: WalletWithdrawalRequestStatus.customError, statusCode: 0, alertMessage: 'Insufficient funds: Withdrawal amount exceeds your available balance.', extraMessage: ''));
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: WalletWithdrawalRequestStatus.customError, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
