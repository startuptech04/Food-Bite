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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/request/restaurant_account_delete_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'account_setting_delete_account_submit_event.dart';
part 'account_setting_delete_account_submit_state.dart';

class AccountSettingDeleteAccountSubmitBloc extends Bloc<AccountSettingDeleteAccountSubmitEvent, AccountSettingDeleteAccountSubmitState> {
  final AuthRepository _authRepository = AuthRepository();
  final AccountRepository _accountRepository = AccountRepository();
  AccountSettingDeleteAccountSubmitBloc() : super(const AccountSettingDeleteAccountSubmitState()) {
    on<AccountSettingDeleteAccountSubmitInitialEvent>(_onAccountSettingDeleteAccountSubmitInitialEvent);
    on<AccountSettingDeleteAccountSubmitYesEvent>(_onAccountSettingDeleteAccountSubmitYesEvent);
  }

  FutureOr<void> _onAccountSettingDeleteAccountSubmitInitialEvent(AccountSettingDeleteAccountSubmitInitialEvent event, Emitter<AccountSettingDeleteAccountSubmitState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "confirm_delete_account"}, 'confirm_delete_account_screen', 'confirm_delete_account_screen');
    emit(state.copyWith(reason: event.reason, status: AccountSettingDeleteAccountSubmitStatus.initial));
  }

  FutureOr<void> _onAccountSettingDeleteAccountSubmitYesEvent(AccountSettingDeleteAccountSubmitYesEvent event, Emitter<AccountSettingDeleteAccountSubmitState> emit) async {
    try {
      emit(state.copyWith(status: AccountSettingDeleteAccountSubmitStatus.loading));
      final String user = await _authRepository.userId();
      final String restaurant = await _accountRepository.getVendorId();
      RestaurantAccountDeleteRequestModel param = RestaurantAccountDeleteRequestModel(reason: state.reason, user: user, restaurant: restaurant);
      DioApiResponse response = await _authRepository.restaurantAccountDelete(param);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel data = ApiStatusResponseModel.fromJson(myMap);
        if (!data.success!) {
          emit(state.copyWith(status: AccountSettingDeleteAccountSubmitStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          await _accountRepository.onLogoutSuccess();
          emit(state.copyWith(status: AccountSettingDeleteAccountSubmitStatus.success));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AccountSettingDeleteAccountSubmitStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AccountSettingDeleteAccountSubmitStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
