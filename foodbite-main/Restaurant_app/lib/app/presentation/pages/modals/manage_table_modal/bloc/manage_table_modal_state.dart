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

part of 'manage_table_modal_bloc.dart';

enum ManageTableModalStatus { initial, submit, submitSuccess, submitFailed }

extension ManageTableModalStatusX on ManageTableModalStatus {
  bool get isInitial => this == ManageTableModalStatus.initial;
  bool get isSubmit => this == ManageTableModalStatus.submit;
  bool get isSubmitSuccess => this == ManageTableModalStatus.submitSuccess;
  bool get isSubmitFailed => this == ManageTableModalStatus.submitFailed;
}

final class ManageTableModalState {
  final bool isNew;
  final String tableId;
  final RestaurantTableNumberField numberField;
  final RestaurantTableCapacityField capacityField;
  final bool isValid;
  final ManageTableModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const ManageTableModalState({
    this.isNew = false,
    this.tableId = '',
    this.numberField = const RestaurantTableNumberField.pure(),
    this.capacityField = const RestaurantTableCapacityField.pure(),
    this.isValid = false,
    this.status = ManageTableModalStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  ManageTableModalState copyWith({
    bool? isNew,
    String? tableId,
    RestaurantTableNumberField? numberField,
    RestaurantTableCapacityField? capacityField,
    bool? isValid,
    ManageTableModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return ManageTableModalState(
      isNew: isNew ?? this.isNew,
      tableId: tableId ?? this.tableId,
      numberField: numberField ?? this.numberField,
      capacityField: capacityField ?? this.capacityField,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
