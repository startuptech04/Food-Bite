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

part of 'select_delivery_time_modal_bloc.dart';

sealed class SelectDeliveryTimeModalEvent {}

final class SelectDeliveryTimeModalInitialEvent extends SelectDeliveryTimeModalEvent {
  final String deliveryTime;
  SelectDeliveryTimeModalInitialEvent({required this.deliveryTime});
}

final class SelectDeliveryTimeModalFromChangeEvent extends SelectDeliveryTimeModalEvent {
  final String from;
  SelectDeliveryTimeModalFromChangeEvent({required this.from});
}

final class SelectDeliveryTimeModalFromUnfocusedEvent extends SelectDeliveryTimeModalEvent {}

final class SelectDeliveryTimeModalToChangeEvent extends SelectDeliveryTimeModalEvent {
  final String to;
  SelectDeliveryTimeModalToChangeEvent({required this.to});
}

final class SelectDeliveryTimeModalToUnfocusedEvent extends SelectDeliveryTimeModalEvent {}

final class SelectDeliveryTimeChangeEvent extends SelectDeliveryTimeModalEvent {
  final DeliveryTimeTimeModel time;
  SelectDeliveryTimeChangeEvent({required this.time});
}
