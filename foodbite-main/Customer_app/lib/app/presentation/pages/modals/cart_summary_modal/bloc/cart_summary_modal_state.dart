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

part of 'cart_summary_modal_bloc.dart';

enum CartSummaryModalStatus { initial, empty, failure, updateCart, unauthorized, authorized, guestCheckoutStart, guestCheckoutSuccess, guestCheckoutFailed }

extension CartSummaryModalStatusX on CartSummaryModalStatus {
  bool get isInitial => this == CartSummaryModalStatus.initial;
  bool get isEmpty => this == CartSummaryModalStatus.empty;
  bool get isFailure => this == CartSummaryModalStatus.failure;
  bool get isUpdateCart => this == CartSummaryModalStatus.updateCart;
  bool get isUnauthorized => this == CartSummaryModalStatus.unauthorized;
  bool get isAuthorized => this == CartSummaryModalStatus.authorized;
  bool get isGuestCheckoutStart => this == CartSummaryModalStatus.guestCheckoutStart;
  bool get isGuestCheckoutSuccess => this == CartSummaryModalStatus.guestCheckoutSuccess;
  bool get isGuestCheckoutFailed => this == CartSummaryModalStatus.guestCheckoutFailed;
}

final class CartSummaryModalState {
  final List<CartSummaryModel> summary;
  final String checkoutName;
  final String checkoutRestaurant;
  final bool guestCheckout;
  final CartSummaryModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CartSummaryModalState({
    this.summary = const [],
    this.checkoutName = '',
    this.checkoutRestaurant = '',
    this.guestCheckout = false,
    this.status = CartSummaryModalStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  CartSummaryModalState copyWith({
    List<CartSummaryModel>? summary,
    String? checkoutName,
    String? checkoutRestaurant,
    bool? guestCheckout,
    CartSummaryModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return CartSummaryModalState(
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
