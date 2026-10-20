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

sealed class LocationSearchEvent {}

final class LocationSearchInitialEvent extends LocationSearchEvent {}

final class LocationSearchInputEvent extends LocationSearchEvent {
  final String searchText;
  LocationSearchInputEvent({required this.searchText});
}

final class LocationSearchLocalSelectEvent extends LocationSearchEvent {
  final LocalSearchHistoryModel localResult;
  LocationSearchLocalSelectEvent({required this.localResult});
}

final class LocationSearchSelectEvent extends LocationSearchEvent {
  final Predictions predictions;
  LocationSearchSelectEvent({required this.predictions});
}

final class LocationSearchLiveLocationEvent extends LocationSearchEvent {}

final class LocationSearchOpenSettingEvent extends LocationSearchEvent {}

final class LocationSearchSavedAddressEvent extends LocationSearchEvent {
  final AddressDataModel result;
  LocationSearchSavedAddressEvent({required this.result});
}

final class LocationSearchExecuteEvent extends LocationSearchEvent {
  final String query;
  LocationSearchExecuteEvent({required this.query});
}
