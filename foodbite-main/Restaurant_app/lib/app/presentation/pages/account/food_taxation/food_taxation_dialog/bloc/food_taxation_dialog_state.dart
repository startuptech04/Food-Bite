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

part of 'food_taxation_dialog_bloc.dart';

enum FoodTaxationDialogStatus { loading, loaded, initial, inProgress, success, failure }

extension FoodTaxationDialogStatusX on FoodTaxationDialogStatus {
  bool get isLoading => this == FoodTaxationDialogStatus.loading;
  bool get isLoaded => this == FoodTaxationDialogStatus.loaded;
  bool get isInitial => this == FoodTaxationDialogStatus.initial;
  bool get isInProgress => this == FoodTaxationDialogStatus.inProgress;
  bool get isSuccess => this == FoodTaxationDialogStatus.success;
  bool get isFailure => this == FoodTaxationDialogStatus.failure;
}

final class FoodTaxationDialogState {
  final bool isNew;
  final String taxId;
  final FoodTaxationNameField name;
  final FoodTaxationAmountField amount;
  final bool isValid;
  final FoodTaxationDialogStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FoodTaxationDialogState({
    this.isNew = false,
    this.taxId = '',
    this.name = const FoodTaxationNameField.pure(),
    this.amount = const FoodTaxationAmountField.pure(),
    this.isValid = false,
    this.status = FoodTaxationDialogStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FoodTaxationDialogState copyWith({
    bool? isNew,
    String? taxId,
    FoodTaxationNameField? name,
    FoodTaxationAmountField? amount,
    bool? isValid,
    FoodTaxationDialogStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return FoodTaxationDialogState(
      isNew: isNew ?? this.isNew,
      taxId: taxId ?? this.taxId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
