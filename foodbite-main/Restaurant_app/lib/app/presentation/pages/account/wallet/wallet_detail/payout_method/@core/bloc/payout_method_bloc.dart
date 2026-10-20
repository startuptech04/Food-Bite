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
import 'package:vendor/app/core/models/my_payout_method_list_model.dart';
import 'package:vendor/app/core/models/request/change_payout_default_status_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/wallet_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'payout_method_event.dart';
part 'payout_method_state.dart';

class PayoutMethodBloc extends Bloc<PayoutMethodEvent, PayoutMethodState> {
  final WalletRepository _walletRepository = WalletRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PayoutMethodBloc()
    : super(
        PayoutMethodState(
          model: MyPayoutMethodListModel(methods: [], locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<PayoutMethodInitialEvent>(_onPayoutMethodInitialEvent);
    on<PayoutMethodLoadMoreEvent>(_onPayoutMethodLoadMoreEvent);
    on<PayoutMethodDeleteEvent>(_onPayoutMethodDeleteEvent);
    on<PayoutMethodChangeDefaultMethodEvent>(_onPayoutMethodChangeDefaultMethodEvent);
  }

  FutureOr<void> _onPayoutMethodInitialEvent(PayoutMethodInitialEvent event, Emitter<PayoutMethodState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "payout_methods"}, 'payout_methods_screen', 'payout_methods_screen');
      emit(state.copyWith(status: PayoutMethodStatus.loading));
      DioApiResponse response = await _walletRepository.myPayoutMethodList(state.pageSize, state.currentPage);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        MyPayoutMethodListModel data = MyPayoutMethodListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(model: data, status: data.methods!.isEmpty ? PayoutMethodStatus.empty : PayoutMethodStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PayoutMethodStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PayoutMethodStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPayoutMethodLoadMoreEvent(PayoutMethodLoadMoreEvent event, Emitter<PayoutMethodState> emit) async {
    if (state.model.methods!.length < state.model.totalResults!) {
      try {
        emit(state.copyWith(loadMore: true));
        DioApiResponse response = await _walletRepository.myPayoutMethodList(state.pageSize * 2, state.currentPage);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          MyPayoutMethodListModel data = MyPayoutMethodListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, loadMore: false, pageSize: state.pageSize * 2, status: data.methods!.isEmpty ? PayoutMethodStatus.empty : PayoutMethodStatus.success));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: PayoutMethodStatus.customError, loadMore: false, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: PayoutMethodStatus.customError, loadMore: false, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onPayoutMethodDeleteEvent(PayoutMethodDeleteEvent event, Emitter<PayoutMethodState> emit) async {
    try {
      emit(state.copyWith(status: PayoutMethodStatus.loadingDeleteStart));
      DioApiResponse response = await _walletRepository.deletePayoutMethod(state.model.methods![event.index].id!);
      if (response.errorType == NetErrorType.none) {
        state.model.methods!.removeAt(event.index);
        emit(state.copyWith(model: state.model, status: PayoutMethodStatus.loadingDeleteSuccess));
        emit(state.copyWith(status: state.model.methods!.isEmpty ? PayoutMethodStatus.empty : PayoutMethodStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PayoutMethodStatus.loadingDeleteFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PayoutMethodStatus.loadingDeleteFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPayoutMethodChangeDefaultMethodEvent(PayoutMethodChangeDefaultMethodEvent event, Emitter<PayoutMethodState> emit) async {
    try {
      emit(state.copyWith(status: PayoutMethodStatus.loadingDefaultChangeStart));
      ChangePayoutDefaultStatusRequestModel param = ChangePayoutDefaultStatusRequestModel(
        id: state.model.methods![event.index].id!,
        restaurant: await _walletRepository.getVendorId(),
        isDefault: !state.model.methods![event.index].isDefault!,
      );
      DioApiResponse response = await _walletRepository.changeDefaultPayout(param);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: PayoutMethodStatus.loadingDefaultChangeSuccess));
        add(PayoutMethodInitialEvent());
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PayoutMethodStatus.loadingDeleteFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PayoutMethodStatus.loadingDefaultChangeFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
