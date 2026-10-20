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

part of 'location_maps_bloc.dart';

sealed class LocationMapsEvent {}

final class LocationMapInitialEvent extends LocationMapsEvent {
  final double latitude;
  final double longitude;
  final String placeId;
  final String title;
  final String description;
  LocationMapInitialEvent({required this.latitude, required this.longitude, required this.placeId, required this.title, required this.description});
}

final class LocationMapPositionChangedEvent extends LocationMapsEvent {
  final double latitude;
  final double longitude;
  LocationMapPositionChangedEvent({required this.latitude, required this.longitude});
}

final class LocationMapPositionEndedEvent extends LocationMapsEvent {}

final class LocationMapsConfirmEvent extends LocationMapsEvent {}

final class LocationMapsLocateMeEvent extends LocationMapsEvent {}

final class LocationMapsOpenSettingEvent extends LocationMapsEvent {}
