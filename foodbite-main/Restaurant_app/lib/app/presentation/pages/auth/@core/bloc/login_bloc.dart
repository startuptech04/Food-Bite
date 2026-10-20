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
import 'package:flutter/material.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/auth_repository.dart';
import 'package:vendor/app/env.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AuthRepository();
  final AccountRepository _accountRepository = AccountRepository();
  LoginBloc() : super(const LoginState()) {
    on<LoginInitialEvent>(_onLoginInitialEvent);
    on<LoginLanguageChangeEvent>(_onLoginLanguageChangeEvent);
  }

  Future<void> _onLoginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "login"}, 'login_screen', 'login_screen');
    final String restaurantLoginWith = await _authRepository.restaurantLoginWith();
    String? locale = await _authRepository.getLocale();
    emit(state.copyWith(restaurantLoginWith: restaurantLoginWith, locale: locale.isNotEmpty ? locale.toString() : Environments.defaultLanguage));
  }

  FutureOr<void> _onLoginLanguageChangeEvent(LoginLanguageChangeEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(locale: event.locale));
  }
}
