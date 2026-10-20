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

part of 'table_complete_order_bloc.dart';

sealed class TableCompleteOrderEvent {}

final class TableCompleteOrderInitialEvent extends TableCompleteOrderEvent {
  final int tableNumber;
  final String tableId;
  TableCompleteOrderInitialEvent({required this.tableNumber, required this.tableId});
}

final class TableCompleteOrderRemovePriceEvent extends TableCompleteOrderEvent {
  final String priceName;
  TableCompleteOrderRemovePriceEvent({required this.priceName});
}

final class TableCompleteOrderDeleteItemEvent extends TableCompleteOrderEvent {
  final String itemId;
  TableCompleteOrderDeleteItemEvent({required this.itemId});
}

final class TableCompleteOrderDiscountTypeChangedEvent extends TableCompleteOrderEvent {
  final String value;
  TableCompleteOrderDiscountTypeChangedEvent({required this.value});
}

final class TableCompleteOrderDiscountChangedEvent extends TableCompleteOrderEvent {
  final String discount;
  TableCompleteOrderDiscountChangedEvent({required this.discount});
}

final class TableCompleteOrderCustomerTypeChangeEvent extends TableCompleteOrderEvent {
  final String value;
  TableCompleteOrderCustomerTypeChangeEvent({required this.value});
}

final class TableCompleteOrderPaymentModelChangeEvent extends TableCompleteOrderEvent {
  final String payment;
  TableCompleteOrderPaymentModelChangeEvent({required this.payment});
}

final class TableCompleteOrderCustomerNameUnfocusedEvent extends TableCompleteOrderEvent {}

final class TableCompleteOrderCustomerNumberUnfocusedEvent extends TableCompleteOrderEvent {}

final class TableCompleteOrderCustomerNameChangedEvent extends TableCompleteOrderEvent {
  final String name;
  TableCompleteOrderCustomerNameChangedEvent({required this.name});
}

final class TableCompleteOrderCustomerCountryCodeChangedEvent extends TableCompleteOrderEvent {
  final String flag;
  final String countryCode;
  TableCompleteOrderCustomerCountryCodeChangedEvent({required this.flag, required this.countryCode});
}

final class TableCompleteOrderCustomerNumberChangedEvent extends TableCompleteOrderEvent {
  final String number;
  TableCompleteOrderCustomerNumberChangedEvent({required this.number});
}

final class TableCompleteOrderCompleteOrderEvent extends TableCompleteOrderEvent {}
