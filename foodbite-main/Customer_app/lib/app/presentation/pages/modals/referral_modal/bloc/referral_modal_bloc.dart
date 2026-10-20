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

part 'referral_modal_event.dart';
part 'referral_modal_state.dart';

class ReferralModalBloc extends Bloc<ReferralModalEvent, ReferralModalState> {
  final AuthRepository _authRepository = AuthRepository();
  ReferralModalBloc() : super(ReferralModalInitial()) {
    on<ReferralModalInitialEvent>(_onReferralModalInitialEvent);
  }

  FutureOr<void> _onReferralModalInitialEvent(ReferralModalInitialEvent event, Emitter<ReferralModalState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "referral_received"}, 'referral_received_screen', 'referral_received_screen');
  }
}
