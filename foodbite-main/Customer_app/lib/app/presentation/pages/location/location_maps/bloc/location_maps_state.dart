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

enum LocationMapsStatus { initial, loading, loaded, current, dragged, failure, deniedForever, confirm }

extension LocationMapStatusX on LocationMapsStatus {
  bool get isInitial => this == LocationMapsStatus.initial;
  bool get isLoading => this == LocationMapsStatus.loading;
  bool get isLoaded => this == LocationMapsStatus.loaded;
  bool get isCurrent => this == LocationMapsStatus.current;
  bool get isDragged => this == LocationMapsStatus.dragged;
  bool get isFailure => this == LocationMapsStatus.failure;
  bool get isDeniedForever => this == LocationMapsStatus.deniedForever;
  bool get isConfirm => this == LocationMapsStatus.confirm;
}

final class LocationMapsState {
  final double latitude;
  final double longitude;
  final String placeId;
  final String title;
  final String description;
  final LocationMapsStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const LocationMapsState({
    this.latitude = 0,
    this.longitude = 0,
    this.placeId = '',
    this.title = '',
    this.description = '',
    this.status = LocationMapsStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  LocationMapsState copyWith({double? latitude, double? longitude, String? placeId, String? title, String? description, LocationMapsStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return LocationMapsState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
