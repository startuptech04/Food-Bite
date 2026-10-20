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

part of 'select_restaurant_type_modal_bloc.dart';

enum SelectRestaurantTypeModalStatus { loading, success, failure, empty, saved }

extension SelectRestaurantTypeModalStatusX on SelectRestaurantTypeModalStatus {
  bool get isLoading => this == SelectRestaurantTypeModalStatus.loading;
  bool get isSuccess => this == SelectRestaurantTypeModalStatus.success;
  bool get isFailure => this == SelectRestaurantTypeModalStatus.failure;
  bool get isEmpty => this == SelectRestaurantTypeModalStatus.empty;
  bool get isSaved => this == SelectRestaurantTypeModalStatus.saved;
}

final class SelectRestaurantTypeModalState {
  final ActiveRestaurantTypeListResponseModel model;
  final List<String> typeIds;
  final List<String> typeNames;
  final SelectRestaurantTypeModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SelectRestaurantTypeModalState({
    required this.model,
    this.typeIds = const [],
    this.typeNames = const [],
    this.status = SelectRestaurantTypeModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  SelectRestaurantTypeModalState copyWith({
    ActiveRestaurantTypeListResponseModel? model,
    List<String>? typeIds,
    List<String>? typeNames,
    SelectRestaurantTypeModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return SelectRestaurantTypeModalState(
      model: model ?? this.model,
      typeIds: typeIds ?? this.typeIds,
      typeNames: typeNames ?? this.typeNames,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
