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
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/models/cart_summary_model.dart';
import 'package:user/app/core/models/request/remove_cart_item_by_restaurant_request_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:user/app/core/repositories/cart_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'cart_summary_modal_event.dart';
part 'cart_summary_modal_state.dart';

class CartSummaryModalBloc extends Bloc<CartSummaryModalEvent, CartSummaryModalState> {
  final CartRepository _cartRepository = CartRepository();
  final AuthRepository _authRepository = AuthRepository();
  CartSummaryModalBloc() : super(const CartSummaryModalState()) {
    on<CartSummaryModalInitialEvent>(_onCartSummaryModalInitialEvent);
    on<CartSummaryModalRemoveCartItemByRestaurantEvent>(_onCartSummaryModalRemoveCartItemByRestaurantEvent);
    on<CartSummaryModalClearCartEvent>(_onCartSummaryModalClearCartEvent);
    on<CartSummaryModalOnCheckoutEvent>(_onCartSummaryModalOnCheckoutEvent);
    on<CartSummaryModalGuestCheckoutEvent>(_onCartSummaryModalGuestCheckoutEvent);
    on<CartSummaryModalChangeInitialEvent>(_onCartSummaryModalChangeInitialEvent);
  }

  FutureOr<void> _onCartSummaryModalInitialEvent(CartSummaryModalInitialEvent event, Emitter<CartSummaryModalState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "cart_summary"}, 'cart_summary_screen', 'cart_summary_screen');
      await _cartRepository.getCartSummary().then((value) {
        emit(state.copyWith(summary: value, status: value.isNotEmpty ? CartSummaryModalStatus.initial : CartSummaryModalStatus.empty));
      });
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CartSummaryModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCartSummaryModalRemoveCartItemByRestaurantEvent(CartSummaryModalRemoveCartItemByRestaurantEvent event, Emitter<CartSummaryModalState> emit) async {
    try {
      await _cartRepository.removeFromCartWithRestaurant(event.restaurantId);
      emit(state.copyWith(status: CartSummaryModalStatus.updateCart));
      await _cartRepository.getCartSummary().then((value) {
        emit(state.copyWith(summary: value, status: value.isNotEmpty ? CartSummaryModalStatus.initial : CartSummaryModalStatus.empty));
      });
      RemoveCartItemByRestaurantRequestModel onlineRemoveParam = RemoveCartItemByRestaurantRequestModel(trackingId: await _cartRepository.trackingId(), restaurant: event.restaurantId);
      DioApiResponse cartOnlineResponse = await _cartRepository.removeFromCartWithRestaurantServer(onlineRemoveParam);
      if (cartOnlineResponse.errorType == NetErrorType.none) {
      } else {
        Map<String, dynamic>? myMap = jsonDecode(cartOnlineResponse.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CartSummaryModalStatus.updateCart, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: CartSummaryModalStatus.updateCart, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCartSummaryModalClearCartEvent(CartSummaryModalClearCartEvent event, Emitter<CartSummaryModalState> emit) async {
    try {
      await _cartRepository.clearCartItems();
      emit(state.copyWith(status: CartSummaryModalStatus.updateCart));
      emit(state.copyWith(summary: [], status: CartSummaryModalStatus.empty));
      final String trackingId = await _cartRepository.trackingId();
      DioApiResponse cartOnlineResponse = await _cartRepository.clearCartItemServer(trackingId);
      if (cartOnlineResponse.errorType == NetErrorType.none) {
      } else {
        Map<String, dynamic>? myMap = jsonDecode(cartOnlineResponse.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: CartSummaryModalStatus.updateCart, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onCartSummaryModalOnCheckoutEvent(CartSummaryModalOnCheckoutEvent event, Emitter<CartSummaryModalState> emit) async {
    bool isAuthorized = await _cartRepository.isAuthorized();
    emit(state.copyWith(checkoutName: event.name, checkoutRestaurant: event.restaurant, status: isAuthorized ? CartSummaryModalStatus.authorized : CartSummaryModalStatus.unauthorized));
  }

  FutureOr<void> _onCartSummaryModalGuestCheckoutEvent(CartSummaryModalGuestCheckoutEvent event, Emitter<CartSummaryModalState> emit) async {}

  FutureOr<void> _onCartSummaryModalChangeInitialEvent(CartSummaryModalChangeInitialEvent event, Emitter<CartSummaryModalState> emit) async {
    emit(state.copyWith(status: CartSummaryModalStatus.initial));
  }
}
