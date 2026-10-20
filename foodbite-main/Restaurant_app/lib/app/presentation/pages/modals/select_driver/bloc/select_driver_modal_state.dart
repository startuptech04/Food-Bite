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

part of 'select_driver_modal_bloc.dart';

enum SelectDriverModalStatus { loading, success, failure, empty, selected }

extension SelectDriverModalStatusX on SelectDriverModalStatus {
  bool get isLoading => this == SelectDriverModalStatus.loading;
  bool get isSuccess => this == SelectDriverModalStatus.success;
  bool get isFailure => this == SelectDriverModalStatus.failure;
  bool get isEmpty => this == SelectDriverModalStatus.empty;
  bool get isSelected => this == SelectDriverModalStatus.selected;
}

final class SelectDriverModalState {
  final ActiveDriverListModel driverList;
  final String savedDriver;
  final SelectDriverModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SelectDriverModalState({required this.driverList, this.savedDriver = '', this.status = SelectDriverModalStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  SelectDriverModalState copyWith({ActiveDriverListModel? driverList, String? savedDriver, SelectDriverModalStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return SelectDriverModalState(
      driverList: driverList ?? this.driverList,
      savedDriver: savedDriver ?? this.savedDriver,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
