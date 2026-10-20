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
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository = AccountRepository();
  AccountBloc() : super(const AccountState()) {
    on<AccountInitialEvent>(_onAccountInitialEvent);
    on<AccountLogoutEvent>(_onAccountLogoutEvent);
    on<AccountChangeThemeEvent>(_onAccountChangeThemeEvent);
  }

  FutureOr<void> _onAccountInitialEvent(AccountInitialEvent event, Emitter<AccountState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "account"}, 'account_screen', 'account_screen');
    final String businessType = await _accountRepository.vendorBusinessType();
    final bool preBookingPermission = await _accountRepository.getPreBookingPermission();
    final bool ownDeliveryman = await _accountRepository.getDeliverymanPermission();
    final bool tiffinSubscription = await _accountRepository.getTiffinSubscriptionPermission();
    final bool waiterPermission = await _accountRepository.getWaiterPermission();
    final bool kitchenPermission = await _accountRepository.getKitchenPermission();
    final bool tableOrderPermission = await _accountRepository.getTableOrderPermission();
    final String authRole = await _accountRepository.getAuthRole();
    final String appLogo = await _accountRepository.appLogo();
    final bool outletPermission = await _accountRepository.getOutletPermission();
    bool haveOutletPermission = false;
    bool haveSubscriptionPackage = false;
    if (authRole == 'vendor' && outletPermission == true) {
      haveOutletPermission = true;
    }
    if (authRole == 'vendor' && businessType == 'subscription') {
      haveSubscriptionPackage = true;
    }
    String? locale = await _accountRepository.getLocale();
    final bool theme = await _accountRepository.currentTheme();
    final String name = await _accountRepository.vendorName();
    final String address = await _accountRepository.vendorAddress();
    final String logo = await _accountRepository.vendorLogo();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version;

    final bool isGoogleLoggedIn = await _accountRepository.isGoogleLoggedIn();
    final bool isFacebookLoggedIn = await _accountRepository.isFacebookLoggedIn();
    emit(
      state.copyWith(
        name: name,
        address: address,
        logo: logo,
        haveSubscriptionPackage: haveSubscriptionPackage,
        haveDeliveryMan: ownDeliveryman,
        havePreBookingPermission: preBookingPermission,
        haveTiffinSubscription: tiffinSubscription,
        haveWaiterPermission: waiterPermission,
        haveKitchenPermission: kitchenPermission,
        haveOutletPermission: haveOutletPermission,
        tableOrderPermission: tableOrderPermission,
        locale: locale,
        lightMode: theme,
        appLogo: appLogo,
        currentVersion: currentVersion,
        isGoogleLoggedIn: isGoogleLoggedIn,
        isFacebookLoggedIn: isFacebookLoggedIn,
        status: AccountStatus.initial,
      ),
    );
  }

  Future<void> _onAccountLogoutEvent(AccountLogoutEvent event, Emitter<AccountState> emit) async {
    try {
      emit(state.copyWith(status: AccountStatus.logoutStart));
      if (state.isGoogleLoggedIn) {
        await GoogleSignIn.instance.disconnect();
      }
      if (state.isFacebookLoggedIn) {
        await FacebookAuth.instance.logOut();
      }
      final String refreshToken = await _accountRepository.getRefreshToken();
      if (refreshToken.isNotEmpty && refreshToken.isNotEmpty) {
        DioApiResponse response = await _accountRepository.logout(refreshToken);
        if (response.errorType == NetErrorType.none) {
          await _accountRepository.onLogoutSuccess();
          emit(state.copyWith(status: AccountStatus.logoutSuccess));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          await _accountRepository.onLogoutSuccess();
          emit(state.copyWith(status: AccountStatus.logoutFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } else {
        await _accountRepository.onLogoutSuccess();
        emit(state.copyWith(status: AccountStatus.logoutSuccess));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AccountStatus.logoutFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onAccountChangeThemeEvent(AccountChangeThemeEvent event, Emitter<AccountState> emit) async {
    bool changeTheme = !state.lightMode;
    emit(state.copyWith(lightMode: changeTheme));
  }
}
