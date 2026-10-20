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
import 'package:driver/app/core/models/account_setting_delete_account_reason_list_response_model.dart';
import 'package:driver/app/core/models/server_error_model.dart';
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'account_setting_delete_account_event.dart';
part 'account_setting_delete_account_state.dart';

class AccountSettingDeleteAccountBloc extends Bloc<AccountSettingDeleteAccountEvent, AccountSettingDeleteAccountState> {
  final AuthRepository _authRepository = AuthRepository();
  AccountSettingDeleteAccountBloc()
    : super(
        AccountSettingDeleteAccountState(
          list: AccountSettingDeleteAccountReasonListResponseModel(result: [], success: false, locale: ''),
        ),
      ) {
    on<AccountSettingDeleteAccountInitialEvent>(_onAccountSettingDeleteAccountInitialEvent);
  }

  FutureOr<void> _onAccountSettingDeleteAccountInitialEvent(AccountSettingDeleteAccountInitialEvent event, Emitter<AccountSettingDeleteAccountState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "delete_account"}, 'delete_account_screen', 'delete_account_screen');
      emit(state.copyWith(status: AccountSettingDeleteAccountStatus.loading));
      DioApiResponse response = await _authRepository.getAccountDeleteReason();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        AccountSettingDeleteAccountReasonListResponseModel data = AccountSettingDeleteAccountReasonListResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: data.result!.isNotEmpty ? AccountSettingDeleteAccountStatus.success : AccountSettingDeleteAccountStatus.empty, list: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AccountSettingDeleteAccountStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AccountSettingDeleteAccountStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
