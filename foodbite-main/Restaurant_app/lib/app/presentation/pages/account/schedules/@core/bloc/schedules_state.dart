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

part of 'schedules_bloc.dart';

enum SchedulesStatus { loading, success, customError, updateStart, updateSuccess, updateFailed, failure }

extension SchedulesStatusX on SchedulesStatus {
  bool get isLoading => this == SchedulesStatus.loading;
  bool get isSuccess => this == SchedulesStatus.success;
  bool get isCustomError => this == SchedulesStatus.customError;
  bool get isUpdateStart => this == SchedulesStatus.updateStart;
  bool get isUpdateSucces => this == SchedulesStatus.updateSuccess;
  bool get isUpdateFailed => this == SchedulesStatus.updateFailed;
  bool get isFailure => this == SchedulesStatus.failure;
}

const List<String> daysList = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

final class SchedulesState {
  final SlotListModel list;
  final SchedulesStatus status;
  final List<String> daysName;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SchedulesState({required this.list, this.status = SchedulesStatus.loading, this.daysName = daysList, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  SchedulesState copyWith({SlotListModel? list, SchedulesStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return SchedulesState(list: list ?? this.list, status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage, statusCode: statusCode ?? this.statusCode);
  }
}
