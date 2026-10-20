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

part of 'select_restaurant_facilities_modal_bloc.dart';

enum SelectRestaurantFacilitiesModalStatus { loading, success, failure, empty, saved }

extension SelectRestaurantFacilitiesModalStatusX on SelectRestaurantFacilitiesModalStatus {
  bool get isLoading => this == SelectRestaurantFacilitiesModalStatus.loading;
  bool get isSuccess => this == SelectRestaurantFacilitiesModalStatus.success;
  bool get isFailure => this == SelectRestaurantFacilitiesModalStatus.failure;
  bool get isEmpty => this == SelectRestaurantFacilitiesModalStatus.empty;
  bool get isSaved => this == SelectRestaurantFacilitiesModalStatus.saved;
}

final class SelectRestaurantFacilitiesModalState {
  final ActiveRestaurantFacilitiyListModel model;
  final List<String> facilityIds;
  final List<String> facilityNames;
  final SelectRestaurantFacilitiesModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SelectRestaurantFacilitiesModalState({
    required this.model,
    this.facilityIds = const [],
    this.facilityNames = const [],
    this.status = SelectRestaurantFacilitiesModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  SelectRestaurantFacilitiesModalState copyWith({
    ActiveRestaurantFacilitiyListModel? model,
    List<String>? facilityIds,
    List<String>? facilityNames,
    SelectRestaurantFacilitiesModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return SelectRestaurantFacilitiesModalState(
      model: model ?? this.model,
      facilityIds: facilityIds ?? this.facilityIds,
      facilityNames: facilityNames ?? this.facilityNames,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
