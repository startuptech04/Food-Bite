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

part of 'cart_bloc.dart';

enum CartStatus { loading, empty, success, failure, customError, cartUpdate, cartError, unauthorized, authorized, guestCheckoutStart, guestCheckoutSuccess, guestCheckoutFailed }

extension CartStatusX on CartStatus {
  bool get isLoading => this == CartStatus.loading;
  bool get isEmpty => this == CartStatus.empty;
  bool get isSuccess => this == CartStatus.success;
  bool get isFailure => this == CartStatus.failure;
  bool get isCustomError => this == CartStatus.customError;
  bool get isCartUpdate => this == CartStatus.cartUpdate;
  bool get isCartError => this == CartStatus.cartError;
  bool get isUnauthorized => this == CartStatus.unauthorized;
  bool get isAuthorized => this == CartStatus.authorized;
  bool get isGuestCheckoutStart => this == CartStatus.guestCheckoutStart;
  bool get isGuestCheckoutSuccess => this == CartStatus.guestCheckoutSuccess;
  bool get isGuestCheckoutFailed => this == CartStatus.guestCheckoutFailed;
}

final class CartState {
  final List<CartSummaryModel> summary;
  final String checkoutName;
  final String checkoutRestaurant;
  final bool guestCheckout;
  final CartStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CartState({this.summary = const [], this.checkoutName = '', this.checkoutRestaurant = '', this.guestCheckout = false, this.status = CartStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  CartState copyWith({List<CartSummaryModel>? summary, String? checkoutName, String? checkoutRestaurant, bool? guestCheckout, CartStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return CartState(
      summary: summary ?? this.summary,
      checkoutName: checkoutName ?? this.checkoutName,
      checkoutRestaurant: checkoutRestaurant ?? this.checkoutRestaurant,
      guestCheckout: guestCheckout ?? this.guestCheckout,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
