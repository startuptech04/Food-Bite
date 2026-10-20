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

part of 'pos_place_order_bloc.dart';

sealed class PosPlaceOrderEvent {}

final class PosPlaceOrderInitialEvent extends PosPlaceOrderEvent {}

final class PosPlaceOrderQuantityEvent extends PosPlaceOrderEvent {
  final String id;
  final String uuid;
  final String action;
  PosPlaceOrderQuantityEvent({required this.id, required this.uuid, required this.action});
}

final class PosPlaceOrderRemovePriceEvent extends PosPlaceOrderEvent {
  final String priceName;
  PosPlaceOrderRemovePriceEvent({required this.priceName});
}

final class PosPlaceOrderDiscountTypeChangedEvent extends PosPlaceOrderEvent {
  final String value;
  PosPlaceOrderDiscountTypeChangedEvent({required this.value});
}

final class PosPlaceOrderDiscountChangedEvent extends PosPlaceOrderEvent {
  final String discount;
  PosPlaceOrderDiscountChangedEvent({required this.discount});
}

final class PosPlaceOrderCustomerTypeChangeEvent extends PosPlaceOrderEvent {
  final String value;
  PosPlaceOrderCustomerTypeChangeEvent({required this.value});
}

final class PosPlaceOrderPaymentModelChangeEvent extends PosPlaceOrderEvent {
  final String payment;
  PosPlaceOrderPaymentModelChangeEvent({required this.payment});
}

final class PosPlaceOrderCustomerNameUnfocusedEvent extends PosPlaceOrderEvent {}

final class PosPlaceOrderCustomerNumberUnfocusedEvent extends PosPlaceOrderEvent {}

final class PosPlaceOrderCustomerNameChangedEvent extends PosPlaceOrderEvent {
  final String name;
  PosPlaceOrderCustomerNameChangedEvent({required this.name});
}

final class PosPlaceOrderCustomerCountryCodeChangedEvent extends PosPlaceOrderEvent {
  final String flag;
  final String countryCode;
  PosPlaceOrderCustomerCountryCodeChangedEvent({required this.flag, required this.countryCode});
}

final class PosPlaceOrderCustomerNumberChangedEvent extends PosPlaceOrderEvent {
  final String number;
  PosPlaceOrderCustomerNumberChangedEvent({required this.number});
}

final class PosPlaceOrderSubmitEvent extends PosPlaceOrderEvent {}
