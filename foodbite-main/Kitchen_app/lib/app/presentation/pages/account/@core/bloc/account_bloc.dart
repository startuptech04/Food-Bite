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
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/models/server_error_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/env.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthRepository _authRepository = AuthRepository();
  AccountBloc() : super(const AccountState()) {
    on<AccountInitialEvent>(_onAccountInitialEvent);
    on<AccountLogoutEvent>(_onAccountLogoutEvent);
    on<AccountChangeThemeEvent>(_onAccountChangeThemeEvent);
  }

  FutureOr<void> _onAccountInitialEvent(AccountInitialEvent event, Emitter<AccountState> emit) async {
    String userCoverImage = '';
    String userName = '';
    String userEmailAddress = '';
    await _authRepository.saveEvent('visited_screen', {"screen": "account"}, 'account_screen', 'account_screen');
    final String userFirstName = await _authRepository.kitchenFirstName();
    final String userLastName = await _authRepository.kitchenLastName();
    final String userEmail = await _authRepository.kitchenEmail();
    final String userCover = await _authRepository.kitchenCover();
    final String locale = await _authRepository.getLocale();
    final String appLogo = await _authRepository.appLogo();
    userName = '$userFirstName $userLastName';
    userEmailAddress = userEmail;
    userCoverImage = userCover;
    final theme = await _authRepository.currentTheme();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version;
    final bool isGoogleLoggedIn = await _authRepository.isGoogleLoggedIn();
    final bool isFacebookLoggedIn = await _authRepository.isFacebookLoggedIn();
    emit(
      state.copyWith(
        kitchenOwnerName: userName,
        kitchenOwnerCover: userCoverImage,
        kitchenOwnerEmail: userEmailAddress,
        lightMode: theme,
        locale: locale.isNotEmpty ? locale : Environments.defaultLanguage,
        appLogo: appLogo,
        currentVersion: currentVersion,
        isGoogleLoggedIn: isGoogleLoggedIn,
        isFacebookLoggedIn: isFacebookLoggedIn,
        status: AccountStatus.initial,
      ),
    );
  }

  FutureOr<void> _onAccountLogoutEvent(AccountLogoutEvent event, Emitter<AccountState> emit) async {
    try {
      emit(state.copyWith(status: AccountStatus.logoutStart));
      if (state.isGoogleLoggedIn) {
        await GoogleSignIn.instance.disconnect();
      }
      if (state.isFacebookLoggedIn) {
        await FacebookAuth.instance.logOut();
      }
      String? refreshToken = await _authRepository.getRefreshToken();
      if (refreshToken.isNotEmpty) {
        DioApiResponse response = await _authRepository.logout(refreshToken);
        if (response.errorType == NetErrorType.none) {
          await _authRepository.onLogoutSuccess();
          emit(state.copyWith(status: AccountStatus.logoutSuccess));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          await _authRepository.onLogoutSuccess();
          emit(state.copyWith(status: AccountStatus.logoutFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } else {
        await _authRepository.onLogoutSuccess();
        emit(state.copyWith(status: AccountStatus.logoutSuccess));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AccountStatus.logoutFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onAccountChangeThemeEvent(AccountChangeThemeEvent event, Emitter<AccountState> emit) {
    bool changeTheme = !state.lightMode;
    emit(state.copyWith(lightMode: changeTheme));
  }
}
