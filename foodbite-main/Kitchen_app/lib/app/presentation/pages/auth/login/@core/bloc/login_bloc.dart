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

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/env.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AuthRepository();
  LoginBloc() : super(const LoginState()) {
    on<LoginInitialEvent>(_onLoginInitialEvent);
    on<LoginLanguageChangeEvent>(_onLoginLanguageChangeEvent);
  }

  FutureOr<void> _onLoginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "login"}, 'login_screen', 'login_screen');
      final String waiterLoginWith = await _authRepository.kitchenLoginWith();
      final String locale = await _authRepository.getLocale();
      emit(state.copyWith(waiterLoginWith: waiterLoginWith, locale: locale.isNotEmpty ? locale.toString() : Environments.defaultLanguage));
    } catch (e, stacktrace) {
      emit(state.copyWith(waiterLoginWith: 'email_password', status: LoginStatus.notificationDicline));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onLoginLanguageChangeEvent(LoginLanguageChangeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(locale: event.locale));
  }
}
