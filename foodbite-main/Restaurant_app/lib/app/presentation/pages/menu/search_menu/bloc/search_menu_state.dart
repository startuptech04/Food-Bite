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

part of 'search_menu_bloc.dart';

enum SearchMenuStatus { initial, empty, success, failure }

extension SearchMenuStatusX on SearchMenuStatus {
  bool get isInitial => this == SearchMenuStatus.initial;
  bool get isSuccess => this == SearchMenuStatus.success;
  bool get isFailure => this == SearchMenuStatus.failure;
  bool get isEmpty => this == SearchMenuStatus.empty;
}

final class SearchMenuState {
  final SearchMenuResponseModel model;
  final SearchMenuStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SearchMenuState({required this.model, this.status = SearchMenuStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  SearchMenuState copyWith({SearchMenuResponseModel? model, SearchMenuStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return SearchMenuState(model: model ?? this.model, status: status ?? this.status, statusCode: statusCode ?? this.statusCode, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
