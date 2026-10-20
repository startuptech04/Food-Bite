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

part of 'dining_booking_search_bloc.dart';

enum DiningBookingSearchStatus { initial, loading, success, failure, empty }

extension DiningBookingSearchStatusX on DiningBookingSearchStatus {
  bool get isInitial => this == DiningBookingSearchStatus.initial;
  bool get isLoading => this == DiningBookingSearchStatus.loading;
  bool get isSuccess => this == DiningBookingSearchStatus.success;
  bool get isFailure => this == DiningBookingSearchStatus.failure;
  bool get isEmpty => this == DiningBookingSearchStatus.empty;
}

final class DiningBookingSearchState {
  final String query;
  final DiningBookingSearchResponseModel model;
  final DiningBookingSearchStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningBookingSearchState({this.query = '', required this.model, this.status = DiningBookingSearchStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  DiningBookingSearchState copyWith({String? query, DiningBookingSearchResponseModel? model, DiningBookingSearchStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return DiningBookingSearchState(
      query: query ?? this.query,
      model: model ?? this.model,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
