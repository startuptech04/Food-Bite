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

part of 'location_search_bloc.dart';

enum LocationSearchStatus { initial, loading, failure, success, listed, selected, historySelected, liveLoading, deniedForever }

extension LocationSearchStatusX on LocationSearchStatus {
  bool get isInitial => this == LocationSearchStatus.initial;
  bool get isLoading => this == LocationSearchStatus.loading;
  bool get isFailure => this == LocationSearchStatus.failure;
  bool get isSuccess => this == LocationSearchStatus.success;
  bool get isListed => this == LocationSearchStatus.listed;
  bool get isSelected => this == LocationSearchStatus.selected;
  bool get isHistorySelected => this == LocationSearchStatus.historySelected;
  bool get isLiveLoading => this == LocationSearchStatus.liveLoading;
  bool get isDeniedForever => this == LocationSearchStatus.deniedForever;
}

final class LocationSearchState {
  final List<Predictions> predictions;
  final List<LocalSearchHistoryModel> localHistory;
  final MyAddressListResponseModel addresses;
  final double latitude;
  final double longitude;
  final String placeId;
  final String title;
  final String description;
  final LocationSearchStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const LocationSearchState({
    this.predictions = const [],
    this.localHistory = const [],
    required this.addresses,
    this.latitude = 0,
    this.longitude = 0,
    this.placeId = '',
    this.title = '',
    this.description = '',
    this.status = LocationSearchStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  LocationSearchState copyWith({
    GooglePlacesModel? results,
    List<Predictions>? predictions,
    List<LocalSearchHistoryModel>? localHistory,
    MyAddressListResponseModel? addresses,
    double? latitude,
    double? longitude,
    String? placeId,
    String? title,
    String? description,
    LocationSearchStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return LocationSearchState(
      predictions: predictions ?? this.predictions,
      localHistory: localHistory ?? this.localHistory,
      addresses: addresses ?? this.addresses,
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
