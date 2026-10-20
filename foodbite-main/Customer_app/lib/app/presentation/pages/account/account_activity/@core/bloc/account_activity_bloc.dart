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

part 'account_activity_event.dart';
part 'account_activity_state.dart';

class AccountActivityBloc extends Bloc<AccountActivityEvent, AccountActivityState> {
  final AuthRepository _authRepository = AuthRepository();
  AccountActivityBloc() : super(AccountActivityStateInitial()) {
    on<AccountActivityInitialEvent>(_onAccountActivityInitialEvent);
  }

  FutureOr<void> _onAccountActivityInitialEvent(AccountActivityInitialEvent event, Emitter<AccountActivityState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "account_activity"}, 'account_activity_screen', 'account_activity_screen');
  }
}
