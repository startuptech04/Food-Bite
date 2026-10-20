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

part of 'new_address_map_bloc.dart';

sealed class NewAddressMapEvent {}

final class NewAddressMapInitialEvent extends NewAddressMapEvent {
  final bool isNew;
  final bool fromDelivery;
  final String id;
  final double latitude;
  final double longitude;
  final int title;
  final String receiverName;
  final String countryCode;
  final String receiverContact;
  final String flatHouse;
  final String locality;
  final String landmark;
  NewAddressMapInitialEvent({
    required this.isNew,
    required this.fromDelivery,
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.receiverName,
    required this.countryCode,
    required this.receiverContact,
    required this.flatHouse,
    required this.locality,
    required this.landmark,
  });
}

final class NewAddressMapOpenSettingEvent extends NewAddressMapEvent {}

final class NewAddressMapLocateMeEvent extends NewAddressMapEvent {}

final class NewAddressMapPositionChangedEvent extends NewAddressMapEvent {
  final double latitude;
  final double longitude;
  NewAddressMapPositionChangedEvent({required this.latitude, required this.longitude});
}

final class NewAddressMapPositionEndedEvent extends NewAddressMapEvent {}
