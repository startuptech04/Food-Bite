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

part 'web_otp_modal_event.dart';
part 'web_otp_modal_state.dart';

class WebOtpModalBloc extends Bloc<WebOtpModalEvent, WebOtpModalState> {
  final AuthRepository _authRepository = AuthRepository();
  WebOtpModalBloc() : super(const WebOtpModalState()) {
    on<WebOtpModalInitialEvent>(_onWebOtpModalInitialEvent);
    on<WebOtpModalResponseEvent>(_onWebOtpModalResponseEvent);
  }

  FutureOr<void> _onWebOtpModalInitialEvent(WebOtpModalInitialEvent event, Emitter<WebOtpModalState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "web_otp_verification"}, 'web_otp_verification_screen', 'web_otp_verification_screen');
    emit(state.copyWith(status: WebOtpModalStatus.initial, otpId: event.otpId, locale: event.locale));
  }

  FutureOr<void> _onWebOtpModalResponseEvent(WebOtpModalResponseEvent event, Emitter<WebOtpModalState> emit) async {
    emit(state.copyWith(dummyOTP: event.dummyOTP, status: event.isSuccess ? WebOtpModalStatus.success : WebOtpModalStatus.failed));
  }
}
