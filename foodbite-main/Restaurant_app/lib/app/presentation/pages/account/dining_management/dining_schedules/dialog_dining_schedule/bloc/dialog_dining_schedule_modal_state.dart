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

part of 'dialog_dining_schedule_modal_bloc.dart';

enum DialogDiningScheduleModalStatus { initial, success, failure }

extension DialogDiningScheduleModalStatusX on DialogDiningScheduleModalStatus {
  bool get isInitial => this == DialogDiningScheduleModalStatus.initial;
  bool get isSuccess => this == DialogDiningScheduleModalStatus.success;
  bool get isFailure => this == DialogDiningScheduleModalStatus.failure;
}

final class DialogDiningScheduleModalState {
  final List<DiningScheduleMealTypeModel> typeList;
  final DiningScheduleMealTypeModel type;
  final DiningScheduleTimeField time;
  final bool isValid;
  final DialogDiningScheduleModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DialogDiningScheduleModalState({
    this.typeList = const [],
    required this.type,
    this.time = const DiningScheduleTimeField.pure(),
    this.isValid = false,
    this.status = DialogDiningScheduleModalStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DialogDiningScheduleModalState copyWith({
    List<DiningScheduleMealTypeModel>? typeList,
    DiningScheduleMealTypeModel? type,
    DiningScheduleTimeField? time,
    bool? isValid,
    DialogDiningScheduleModalStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return DialogDiningScheduleModalState(
      typeList: typeList ?? this.typeList,
      type: type ?? this.type,
      time: time ?? this.time,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
