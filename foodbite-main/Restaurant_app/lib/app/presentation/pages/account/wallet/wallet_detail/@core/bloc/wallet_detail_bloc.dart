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

part 'wallet_detail_event.dart';
part 'wallet_detail_state.dart';

class WalletDetailBloc extends Bloc<WalletDetailEvent, WalletDetailState> {
  final AccountRepository _accountRepository = AccountRepository();
  WalletDetailBloc() : super(WalletDetailInitial()) {
    on<WalletDetailInitialEvent>(_onWalletDetailInitialEvent);
  }

  FutureOr<void> _onWalletDetailInitialEvent(WalletDetailInitialEvent event, Emitter<WalletDetailState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "wallet_detail"}, 'wallet_detail_screen', 'wallet_detail_screen');
  }
}
