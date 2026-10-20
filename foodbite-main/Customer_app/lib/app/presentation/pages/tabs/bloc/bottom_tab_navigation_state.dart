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

part of 'bottom_tab_navigation_bloc.dart';

enum BottomTabNavigationStatus { initial, updateCart, updateCartError, unauthorized, authorized, guestCheckoutStart, guestCheckoutSuccess, guestCheckoutFailed }

extension BottomTabNavigationStatusX on BottomTabNavigationStatus {
  bool get isInitial => this == BottomTabNavigationStatus.initial;
  bool get isUpdateCart => this == BottomTabNavigationStatus.updateCart;
  bool get isUpdateCartError => this == BottomTabNavigationStatus.updateCartError;
  bool get isUnauthorized => this == BottomTabNavigationStatus.unauthorized;
  bool get isAuthorized => this == BottomTabNavigationStatus.authorized;
  bool get isGuestCheckoutStart => this == BottomTabNavigationStatus.guestCheckoutStart;
  bool get isGuestCheckoutSuccess => this == BottomTabNavigationStatus.guestCheckoutSuccess;
  bool get isGuestCheckoutFailed => this == BottomTabNavigationStatus.guestCheckoutFailed;
}

final class BottomTabNavigationState {
  final int tabIndex;
  final bool canActivate;
  final String checkoutName;
  final String checkoutRestaurant;
  final bool guestCheckout;
  final List<CartSummaryModel> summary;
  final BottomTabNavigationStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const BottomTabNavigationState({
    this.tabIndex = 0,
    this.canActivate = true,
    this.checkoutName = '',
    this.checkoutRestaurant = '',
    this.guestCheckout = false,
    this.summary = const [],
    this.status = BottomTabNavigationStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  BottomTabNavigationState copyWith({
    int? tabIndex,
    bool? canActivate,
    String? checkoutName,
    String? checkoutRestaurant,
    bool? guestCheckout,
    List<CartSummaryModel>? summary,
    BottomTabNavigationStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return BottomTabNavigationState(
      tabIndex: tabIndex ?? this.tabIndex,
      canActivate: canActivate ?? this.canActivate,
      checkoutName: checkoutName ?? this.checkoutName,
      checkoutRestaurant: checkoutRestaurant ?? this.checkoutRestaurant,
      guestCheckout: guestCheckout ?? this.guestCheckout,
      summary: summary ?? this.summary,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
