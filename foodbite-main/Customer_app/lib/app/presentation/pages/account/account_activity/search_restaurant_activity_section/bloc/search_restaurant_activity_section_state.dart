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

part of 'search_restaurant_activity_section_bloc.dart';

enum SearchRestaurantActivitySectionStatus { initial, empty, success, failure }

extension SearchRestaurantActivitySectionStatusX on SearchRestaurantActivitySectionStatus {
  bool get isInitial => this == SearchRestaurantActivitySectionStatus.initial;
  bool get isSuccess => this == SearchRestaurantActivitySectionStatus.success;
  bool get isFailure => this == SearchRestaurantActivitySectionStatus.failure;
  bool get isEmpty => this == SearchRestaurantActivitySectionStatus.empty;
}

final class SearchRestaurantActivitySectionState {
  final SearchRestaurantForReviewResponseModel model;
  final SearchRestaurantActivitySectionStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SearchRestaurantActivitySectionState({required this.model, this.status = SearchRestaurantActivitySectionStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  SearchRestaurantActivitySectionState copyWith({SearchRestaurantForReviewResponseModel? model, SearchRestaurantActivitySectionStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return SearchRestaurantActivitySectionState(
      model: model ?? this.model,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
