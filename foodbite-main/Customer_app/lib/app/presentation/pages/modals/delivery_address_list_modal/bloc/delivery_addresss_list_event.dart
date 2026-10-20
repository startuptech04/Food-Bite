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

part of 'delivery_addresss_list_bloc.dart';

sealed class DeliveryAddresssListEvent {}

final class DeliveryAddressListInitialEvent extends DeliveryAddresssListEvent {
  final double deliveryArea;
  final String restaurant;
  final String deliveryAddressId;
  DeliveryAddressListInitialEvent({required this.deliveryArea, required this.restaurant, required this.deliveryAddressId});
}

final class DeliveryAddresssRefreshEvent extends DeliveryAddresssListEvent {}

final class DeliveryAddressSelectEvent extends DeliveryAddresssListEvent {
  final String id;
  DeliveryAddressSelectEvent({required this.id});
}
