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

part of 'schedular_time_picker_modal_bloc.dart';

enum SchedularTimePickerModalStatus { initial, success, failure }

extension SchedularTimePickerModalStatusX on SchedularTimePickerModalStatus {
  bool get isInitial => this == SchedularTimePickerModalStatus.initial;
  bool get isSuccess => this == SchedularTimePickerModalStatus.success;
  bool get isFailure => this == SchedularTimePickerModalStatus.failure;
}

final class SchedularTimePickerModalState {
  final StartTimeField startTime;
  final EndTimeField endTime;
  final bool isValid;
  final SchedularTimePickerModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const SchedularTimePickerModalState({
    this.startTime = const StartTimeField.pure(),
    this.endTime = const EndTimeField.pure(),
    this.isValid = false,
    this.status = SchedularTimePickerModalStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  SchedularTimePickerModalState copyWith({StartTimeField? startTime, EndTimeField? endTime, bool? isValid, SchedularTimePickerModalStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return SchedularTimePickerModalState(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
