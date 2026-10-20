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
import 'package:vendor/app/core/repositories/account_repository.dart';

part 'register_request_payment_event.dart';
part 'register_request_payment_state.dart';

class RegisterRequestPaymentBloc extends Bloc<RegisterRequestPaymentEvent, RegisterRequestPaymentState> {
  final AccountRepository _accountRepository = AccountRepository();
  RegisterRequestPaymentBloc() : super(const RegisterRequestPaymentState()) {
    on<RegisterRequestPaymentInitialEvent>(_onRegisterRequestPaymentInitialEvent);
    on<RegisterRequestPaymentResponseEvent>(_onRegisterRequestPaymentResponseEvent);
  }

  FutureOr<void> _onRegisterRequestPaymentInitialEvent(RegisterRequestPaymentInitialEvent event, Emitter<RegisterRequestPaymentState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "restaurant_register_request_payment"}, 'restaurant_register_request_payment_screen', 'restaurant_register_request_payment_screen');
    emit(state.copyWith(status: RegisterRequestPaymentStatus.initial));
  }

  FutureOr<void> _onRegisterRequestPaymentResponseEvent(RegisterRequestPaymentResponseEvent event, Emitter<RegisterRequestPaymentState> emit) async {
    emit(state.copyWith(status: RegisterRequestPaymentStatus.success));
  }
}
