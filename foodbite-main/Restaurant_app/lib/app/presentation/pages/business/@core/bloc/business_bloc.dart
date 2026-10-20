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

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final AccountRepository _accountRepository = AccountRepository();
  BusinessBloc() : super(const BusinessState()) {
    on<BusinessInitialEvent>(_onBusinessInitialEvent);
  }

  FutureOr<void> _onBusinessInitialEvent(BusinessInitialEvent event, Emitter<BusinessState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "business"}, 'business_screen', 'business_screen');
  }
}
