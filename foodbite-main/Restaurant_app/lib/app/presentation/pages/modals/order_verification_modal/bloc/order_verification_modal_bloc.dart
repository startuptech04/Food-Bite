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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vendor/app/core/repositories/account_repository.dart';

part 'order_verification_modal_event.dart';
part 'order_verification_modal_state.dart';

class OrderVerificationModalBloc extends Bloc<OrderVerificationModalEvent, OrderVerificationModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  OrderVerificationModalBloc() : super(const OrderVerificationModalState()) {
    on<OrderVerificationModalInitialEvent>(_onOrderVerificationModalInitialEvent);
    on<OrderVerificationModalOTPChangeEvent>(_onOrderVerificationModalOTPChangeEvent);
    on<OrderVerificationModalCollectedCashEvent>(_onOrderVerificationModalCollectedCashEvent);
    on<OrderVerificationSubmitEvent>(_onOrderVerificationSubmitEvent);
  }

  FutureOr<void> _onOrderVerificationModalInitialEvent(OrderVerificationModalInitialEvent event, Emitter<OrderVerificationModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "order_otp_verification"}, 'order_otp_verification_screen', 'order_otp_verification_screen');
      emit(
        state.copyWith(
          orderId: event.orderId,
          orderTo: event.orderTo,
          customerOrderPin: event.customerOrderPin,
          driverOrderPin: event.driverOrderPin,
          paymentMode: event.paymentMode,
          grandTotal: event.grandTotal,
          isPaymentChecked: event.paymentMode == 'offline' && event.orderTo == 'selfpickup' ? false : true,
          status: OrderVerificationModalStatus.loaded,
        ),
      );
    } catch (e, stacktrace) {
      emit(state.copyWith(status: OrderVerificationModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onOrderVerificationModalOTPChangeEvent(OrderVerificationModalOTPChangeEvent event, Emitter<OrderVerificationModalState> emit) async {
    emit(state.copyWith(otp: event.otp, status: OrderVerificationModalStatus.loaded));
  }

  FutureOr<void> _onOrderVerificationModalCollectedCashEvent(OrderVerificationModalCollectedCashEvent event, Emitter<OrderVerificationModalState> emit) async {
    emit(state.copyWith(isPaymentChecked: state.isPaymentChecked ? false : true, status: OrderVerificationModalStatus.loaded));
  }

  FutureOr<void> _onOrderVerificationSubmitEvent(OrderVerificationSubmitEvent event, Emitter<OrderVerificationModalState> emit) async {
    if (state.otp.isNotEmpty && state.otp.length == state.customerOrderPin.length) {
      final String inputOTP = state.otp.toLowerCase().toString();
      final String checkOTP = state.orderTo == 'homedelivery' ? state.driverOrderPin.toLowerCase().toString() : state.customerOrderPin.toLowerCase().toString();
      if (inputOTP == checkOTP) {
        emit(state.copyWith(status: OrderVerificationModalStatus.verified));
      } else {
        emit(state.copyWith(status: OrderVerificationModalStatus.failure, statusCode: 0, alertMessage: 'Invalid OTP', extraMessage: ''));
      }
    } else {
      emit(state.copyWith(status: OrderVerificationModalStatus.failure, statusCode: 0, alertMessage: 'Please enter valid OTP', extraMessage: ''));
    }
  }
}
