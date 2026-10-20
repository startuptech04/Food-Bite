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

part 'cash_in_hand_event.dart';
part 'cash_in_hand_state.dart';

class CashInHandBloc extends Bloc<CashInHandEvent, CashInHandState> {
  final AccountRepository _accountRepository = AccountRepository();
  CashInHandBloc() : super(CashInHandInitial()) {
    on<CashInHandInitialEvent>(_onCashInHandInitialEvent);
  }

  FutureOr<void> _onCashInHandInitialEvent(CashInHandInitialEvent event, Emitter<CashInHandState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "cash_in_hand"}, 'cash_in_hand_screen', 'cash_in_hand_screen');
  }
}
