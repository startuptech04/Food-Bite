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

part of 'select_cuisine_modal_bloc.dart';

enum SelectCuisineModalStatus { loading, success, failure, empty, saved }

extension SelectCuisineModalStatusX on SelectCuisineModalStatus {
  bool get isLoading => this == SelectCuisineModalStatus.loading;
  bool get isSuccess => this == SelectCuisineModalStatus.success;
  bool get isFailure => this == SelectCuisineModalStatus.failure;
  bool get isEmpty => this == SelectCuisineModalStatus.empty;
  bool get isSaved => this == SelectCuisineModalStatus.saved;
}

final class SelectCuisineModalState {
  final ActiveCuisineListModel model;
  final List<String> cuisineIds;
  final List<String> cuisineNames;
  final SelectCuisineModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SelectCuisineModalState({required this.model, this.cuisineIds = const [], this.cuisineNames = const [], this.status = SelectCuisineModalStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  SelectCuisineModalState copyWith({ActiveCuisineListModel? model, List<String>? cuisineIds, List<String>? cuisineNames, SelectCuisineModalStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return SelectCuisineModalState(
      model: model ?? this.model,
      cuisineIds: cuisineIds ?? this.cuisineIds,
      cuisineNames: cuisineNames ?? this.cuisineNames,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
