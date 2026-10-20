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

part 'make_wallet_payments_event.dart';
part 'make_wallet_payments_state.dart';

class MakeWalletPaymentsBloc extends Bloc<MakeWalletPaymentsEvent, MakeWalletPaymentsState> {
  final AuthRepository _authRepository = AuthRepository();
  MakeWalletPaymentsBloc() : super(const MakeWalletPaymentsState()) {
    on<MakeWalletPaymentsInitialEvent>(_onMakeWalletPaymentsInitialEvent);
    on<MakeWalletPaymentsResponseEvent>(_onMakeWalletPaymentsResponseEvent);
  }

  FutureOr<void> _onMakeWalletPaymentsInitialEvent(MakeWalletPaymentsInitialEvent event, Emitter<MakeWalletPaymentsState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "make_wallet_fund_payments"}, 'make_wallet_payment_screen', 'make_wallet_payment_screen');
    emit(state.copyWith(status: MakeWalletPaymentsStatus.initial));
  }

  FutureOr<void> _onMakeWalletPaymentsResponseEvent(MakeWalletPaymentsResponseEvent event, Emitter<MakeWalletPaymentsState> emit) async {
    emit(state.copyWith(status: MakeWalletPaymentsStatus.success));
  }
}
