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

part of 'dining_on_map_bloc.dart';

enum DiningOnMapStatus { initial, locationFetched, empty, success, failure, customError }

extension DiningOnMapStatusX on DiningOnMapStatus {
  bool get isInitial => this == DiningOnMapStatus.initial;
  bool get isLocationFetched => this == DiningOnMapStatus.locationFetched;
  bool get isEmpty => this == DiningOnMapStatus.empty;
  bool get isSuccess => this == DiningOnMapStatus.success;
  bool get isFailure => this == DiningOnMapStatus.failure;
  bool get isCustomError => this == DiningOnMapStatus.customError;
}

final class DiningOnMapState {
  final NearMeDiningRestaurantsOnMapResponseModel model;
  final double latitude;
  final double longitude;
  final Set<Marker> markers;
  final Set<Polyline> polyline;
  final DiningOnMapStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningOnMapState({
    required this.model,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.markers = const <Marker>{},
    this.polyline = const <Polyline>{},
    this.status = DiningOnMapStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DiningOnMapState copyWith({
    NearMeDiningRestaurantsOnMapResponseModel? model,
    double? latitude,
    double? longitude,
    Set<Marker>? markers,
    Set<Polyline>? polyline,
    DiningOnMapStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DiningOnMapState(
      model: model ?? this.model,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      markers: markers ?? this.markers,
      polyline: polyline ?? this.polyline,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
