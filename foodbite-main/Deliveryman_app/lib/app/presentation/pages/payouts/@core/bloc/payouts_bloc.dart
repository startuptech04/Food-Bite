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

part 'payouts_event.dart';
part 'payouts_state.dart';

class PayoutsBloc extends Bloc<PayoutsEvent, PayoutsState> {
  final AuthRepository _authRepository = AuthRepository();
  PayoutsBloc() : super(const PayoutsState()) {
    on<PayoutsInitialEvent>(_onPayoutsInitialEvent);
  }

  FutureOr<void> _onPayoutsInitialEvent(PayoutsInitialEvent event, Emitter<PayoutsState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "payout"}, 'payout_screen', 'payout_screen');
  }
}
