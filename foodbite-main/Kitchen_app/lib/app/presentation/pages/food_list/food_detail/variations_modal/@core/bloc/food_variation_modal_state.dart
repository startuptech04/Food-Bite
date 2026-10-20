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

part of 'food_variation_modal_bloc.dart';

enum FoodVariationModalStatus { initial, success, failure }

extension FoodVariationModalStatusX on FoodVariationModalStatus {
  bool get isInitial => this == FoodVariationModalStatus.initial;
  bool get isSuccess => this == FoodVariationModalStatus.success;
  bool get isFailure => this == FoodVariationModalStatus.failure;
}

final class FoodVariationModalState {
  final VariationNameField name;
  final String type;
  final VariationMinQuantityField min;
  final VariationMaxQuantityField max;
  final bool isRequired;
  final List<FoodVariationOptionModel> options;
  final bool isValid;
  final FoodVariationModel savedData;
  final FoodVariationModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodVariationModalState({
    this.name = const VariationNameField.pure(),
    this.type = 'multi',
    this.min = const VariationMinQuantityField.pure(),
    this.max = const VariationMaxQuantityField.pure(),
    this.isRequired = false,
    this.options = const <FoodVariationOptionModel>[],
    this.isValid = false,
    required this.savedData,
    this.status = FoodVariationModalStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FoodVariationModalState copyWith({
    VariationNameField? name,
    String? type,
    VariationMinQuantityField? min,
    VariationMaxQuantityField? max,
    bool? isRequired,
    List<FoodVariationOptionModel>? options,
    bool? isValid,
    FoodVariationModel? savedData,
    FoodVariationModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return FoodVariationModalState(
      name: name ?? this.name,
      type: type ?? this.type,
      min: min ?? this.min,
      max: max ?? this.max,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
      isValid: isValid ?? this.isValid,
      savedData: savedData ?? this.savedData,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
