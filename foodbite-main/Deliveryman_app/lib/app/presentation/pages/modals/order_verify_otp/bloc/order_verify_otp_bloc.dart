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

part 'order_verify_otp_event.dart';
part 'order_verify_otp_state.dart';

class OrderVerifyOtpBloc extends Bloc<OrderVerifyOtpEvent, OrderVerifyOtpState> {
  final AuthRepository _authRepository = AuthRepository();
  OrderVerifyOtpBloc() : super(const OrderVerifyOtpState()) {
    on<OrderVerifyOtpInitialEvent>(_onOrderVerifyOtpInitialEvent);
    on<OrderVerifyOtpChangeEvent>(_onOrderVerifyOtpChangeEvent);
    on<OrderVerifyOtpSubmitEvent>(_onOrderVerifyOtpSubmitEvent);
  }

  FutureOr<void> _onOrderVerifyOtpInitialEvent(OrderVerifyOtpInitialEvent event, Emitter<OrderVerifyOtpState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "order_otp_verification"}, 'order_otp_verification_screen', 'order_otp_verification_screen');
    emit(state.copyWith(status: OrderVerifyOtpStatus.loaded, orderId: event.orderId, customerOrderPin: event.customerPin));
  }

  FutureOr<void> _onOrderVerifyOtpChangeEvent(OrderVerifyOtpChangeEvent event, Emitter<OrderVerifyOtpState> emit) async {
    emit(state.copyWith(otp: event.otp, status: OrderVerifyOtpStatus.loaded));
  }

  FutureOr<void> _onOrderVerifyOtpSubmitEvent(OrderVerifyOtpSubmitEvent event, Emitter<OrderVerifyOtpState> emit) async {
    if (state.otp.isNotEmpty && state.otp.length == state.customerOrderPin.length) {
      final String inputOTP = state.otp.toLowerCase().toString();
      final String checkOTP = state.customerOrderPin.toLowerCase().toString();
      if (inputOTP == checkOTP) {
        emit(state.copyWith(status: OrderVerifyOtpStatus.verified));
      } else {
        emit(state.copyWith(status: OrderVerifyOtpStatus.failure, statusCode: 0, alertMessage: 'Invalid OTP', extraMessage: ''));
      }
    }
  }
}
