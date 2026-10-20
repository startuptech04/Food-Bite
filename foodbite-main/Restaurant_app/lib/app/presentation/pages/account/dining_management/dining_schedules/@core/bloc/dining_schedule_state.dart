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

part of 'dining_schedule_bloc.dart';

enum DiningScheduleStatus { loading, success, failure, customError, updateStart, updateSuccess, updateFailed }

extension DiningScheduleStatusX on DiningScheduleStatus {
  bool get isLoading => this == DiningScheduleStatus.loading;
  bool get isSuccess => this == DiningScheduleStatus.success;
  bool get isFailure => this == DiningScheduleStatus.failure;
  bool get isCustomError => this == DiningScheduleStatus.customError;
  bool get isUpdateStart => this == DiningScheduleStatus.updateStart;
  bool get isUpdateSuccess => this == DiningScheduleStatus.updateSuccess;
  bool get isUpdateFailed => this == DiningScheduleStatus.updateFailed;
}

const List<String> daysList = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

final class DiningScheduleState {
  final DiningScheduleResponseModel list;
  final List<String> daysName;
  final DiningScheduleStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningScheduleState({required this.list, this.daysName = daysList, this.status = DiningScheduleStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  DiningScheduleState copyWith({DiningScheduleResponseModel? list, DiningScheduleStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return DiningScheduleState(list: list ?? this.list, status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage, statusCode: statusCode ?? this.statusCode);
  }
}
