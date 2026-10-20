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

part 'make_payments_event.dart';
part 'make_payments_state.dart';

class MakePaymentsBloc extends Bloc<MakePaymentsEvent, MakePaymentsState> {
  final AuthRepository _authRepository = AuthRepository();
  MakePaymentsBloc() : super(const MakePaymentsState()) {
    on<MakePaymentsInitialEvent>(_onMakePaymentsInitialEvent);
    on<MakePaymentsResponseEvent>(_onMakePaymentsResponseEvent);
  }

  FutureOr<void> _onMakePaymentsInitialEvent(MakePaymentsInitialEvent event, Emitter<MakePaymentsState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "order_payment"}, 'make_order_payment_screen', 'make_order_payment_screen');
    emit(state.copyWith(status: MakePaymentStatus.initial));
  }

  FutureOr<void> _onMakePaymentsResponseEvent(MakePaymentsResponseEvent event, Emitter<MakePaymentsState> emit) async {
    emit(state.copyWith(status: MakePaymentStatus.success));
  }
}
