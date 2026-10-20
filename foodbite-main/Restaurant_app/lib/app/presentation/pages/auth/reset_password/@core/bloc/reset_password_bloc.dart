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
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository _authRepository = AuthRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ResetPasswordBloc() : super(const ResetPasswordState()) {
    on<ResetPasswordInitialEvent>(_onResetPasswordInitialEvent);
  }

  FutureOr<void> _onResetPasswordInitialEvent(ResetPasswordInitialEvent event, Emitter<ResetPasswordState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "reset_password"}, 'reset_password_screen', 'reset_password_screen');
      final String userResetPasswordWith = await _authRepository.restaurantResetPasswordWith();
      emit(state.copyWith(userResetPasswordWith: userResetPasswordWith.isNotEmpty ? userResetPasswordWith : 'email_otp', status: ResetPasswordStatus.success));
    } catch (e, stacktrace) {
      emit(state.copyWith(userResetPasswordWith: 'email_otp', status: ResetPasswordStatus.success));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
