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
import 'package:user/app/core/repositories/auth_repository.dart';

part 'make_dining_booking_payment_event.dart';
part 'make_dining_booking_payment_state.dart';

class MakeDiningBookingPaymentBloc extends Bloc<MakeDiningBookingPaymentEvent, MakeDiningBookingPaymentState> {
  final AuthRepository _authRepository = AuthRepository();
  MakeDiningBookingPaymentBloc() : super(const MakeDiningBookingPaymentState()) {
    on<MakeDiningBookingPaymentInitialEvent>(_onMakeDiningBookingPaymentInitialEvent);
    on<MakeDiningBookingPaymentResponseEvent>(_onMakeDiningBookingPaymentResponseEvent);
  }

  FutureOr<void> _onMakeDiningBookingPaymentInitialEvent(MakeDiningBookingPaymentInitialEvent event, Emitter<MakeDiningBookingPaymentState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "make_dining_booking_payments"}, 'make_dining_booking_payment_screen', 'make_dining_booking_payment_screen');
    emit(state.copyWith(status: MakeDiningBookingPaymentStatus.initial));
  }

  FutureOr<void> _onMakeDiningBookingPaymentResponseEvent(MakeDiningBookingPaymentResponseEvent event, Emitter<MakeDiningBookingPaymentState> emit) async {
    emit(state.copyWith(status: MakeDiningBookingPaymentStatus.success));
  }
}
