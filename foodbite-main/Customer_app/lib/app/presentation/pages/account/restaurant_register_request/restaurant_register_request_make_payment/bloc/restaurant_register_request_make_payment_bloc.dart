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

part 'restaurant_register_request_make_payment_event.dart';
part 'restaurant_register_request_make_payment_state.dart';

class RestaurantRegisterRequestMakePaymentBloc extends Bloc<RestaurantRegisterRequestMakePaymentEvent, RestaurantRegisterRequestMakePaymentState> {
  final AuthRepository _authRepository = AuthRepository();
  RestaurantRegisterRequestMakePaymentBloc() : super(const RestaurantRegisterRequestMakePaymentState()) {
    on<RestaurantRegisterRequestPaymentInitialEvent>(_onRestaurantRegisterRequestPaymentInitialEvent);
    on<RestaurantRegisterRequestPaymentResponseEvent>(_onRestaurantRegisterRequestPaymentResponseEvent);
  }

  FutureOr<void> _onRestaurantRegisterRequestPaymentInitialEvent(RestaurantRegisterRequestPaymentInitialEvent event, Emitter<RestaurantRegisterRequestMakePaymentState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "restaurant_register_request_payments"}, 'restaurant_register_request_payment_screen', 'restaurant_register_request_payment_screen');
    emit(state.copyWith(status: RestaurantRegisterRequestMakePaymentStatus.initial));
  }

  FutureOr<void> _onRestaurantRegisterRequestPaymentResponseEvent(RestaurantRegisterRequestPaymentResponseEvent event, Emitter<RestaurantRegisterRequestMakePaymentState> emit) async {
    emit(state.copyWith(status: RestaurantRegisterRequestMakePaymentStatus.success));
  }
}
