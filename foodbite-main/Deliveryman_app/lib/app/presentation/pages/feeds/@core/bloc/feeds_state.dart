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

part of 'feeds_bloc.dart';

enum FeedsStatus { loading, success, failure, fetchActiveOrder, customError, empty, driverBlocked, deniedForever, newOrder, unauthorized, newLocation }

extension FeedsStatusX on FeedsStatus {
  bool get isLoading => this == FeedsStatus.loading;
  bool get isSuccess => this == FeedsStatus.success;
  bool get isFailure => this == FeedsStatus.failure;
  bool get isFetchActiveOrder => this == FeedsStatus.fetchActiveOrder;
  bool get isCustomError => this == FeedsStatus.customError;
  bool get isEmpty => this == FeedsStatus.empty;
  bool get isDriverBlocked => this == FeedsStatus.driverBlocked;
  bool get isDeniedForever => this == FeedsStatus.deniedForever;
  bool get isNewOrder => this == FeedsStatus.newOrder;
  bool get isUnauthorized => this == FeedsStatus.unauthorized;
  bool get isNewLocation => this == FeedsStatus.newLocation;
}

final class FeedsState {
  final NearMeTrendingRestaurantsModel response;
  final double latitude;
  final double longitude;
  final double mapZoomLevel;
  final Set<Marker> markers;
  final Set<Polyline> polyline;
  final FeedsStatus status;
  final String orderFrom;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FeedsState({
    required this.response,
    this.latitude = 0,
    this.longitude = 0,
    this.mapZoomLevel = 13,
    this.markers = const <Marker>{},
    this.polyline = const <Polyline>{},
    this.status = FeedsStatus.loading,
    this.orderFrom = '',
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FeedsState copyWith({
    NearMeTrendingRestaurantsModel? response,
    double? latitude,
    double? longitude,
    double? mapZoomLevel,
    Set<Marker>? markers,
    Set<Polyline>? polyline,
    FeedsStatus? status,
    String? orderFrom,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return FeedsState(
      response: response ?? this.response,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mapZoomLevel: mapZoomLevel ?? this.mapZoomLevel,
      markers: markers ?? this.markers,
      polyline: polyline ?? this.polyline,
      status: status ?? this.status,
      orderFrom: orderFrom ?? this.orderFrom,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
