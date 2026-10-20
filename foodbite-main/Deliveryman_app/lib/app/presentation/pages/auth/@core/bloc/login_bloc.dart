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
import 'package:driver/app/core/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AuthRepository();
  LoginBloc() : super(const LoginState()) {
    on<LoginInitialEvent>(_onLoginInitialEvent);
    on<LoginLanguageChangeEvent>(_onLoginLanguageChangeEvent);
  }

  Future<void> _onLoginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "login"}, 'login_screen', 'login_screen');
    String? deliverymanLoginWith = await _authRepository.driverLoginWith();
    final String locale = await _authRepository.getLocale();
    emit(state.copyWith(deliverymanLoginWith: deliverymanLoginWith, locale: locale));
  }

  FutureOr<void> _onLoginLanguageChangeEvent(LoginLanguageChangeEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(locale: event.locale));
  }
}
