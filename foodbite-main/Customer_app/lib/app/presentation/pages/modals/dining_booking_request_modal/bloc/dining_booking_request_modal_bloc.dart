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

part 'dining_booking_request_modal_event.dart';
part 'dining_booking_request_modal_state.dart';

class DiningBookingRequestModalBloc extends Bloc<DiningBookingRequestModalEvent, DiningBookingRequestModalState> {
  final AuthRepository _authRepository = AuthRepository();
  DiningBookingRequestModalBloc() : super(const DiningBookingRequestModalState()) {
    on<DiningBookingRequestModalInitialEvent>(_onDiningBookingRequestModalInitialEvent);
    on<DiningBookingRequestModalInstructionsChangeEvent>(_onDiningBookingRequestModalInstructionsChangeEvent);
  }

  FutureOr<void> _onDiningBookingRequestModalInitialEvent(DiningBookingRequestModalInitialEvent event, Emitter<DiningBookingRequestModalState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "dining_booking_special_request"}, 'dining_booking_special_request_screen', 'dining_booking_special_request_screen');
    emit(state.copyWith(status: DiningBookingRequestModalStatus.success, instructions: event.instructions));
  }

  FutureOr<void> _onDiningBookingRequestModalInstructionsChangeEvent(DiningBookingRequestModalInstructionsChangeEvent event, Emitter<DiningBookingRequestModalState> emit) {
    emit(state.copyWith(instructions: event.instructions));
  }
}
