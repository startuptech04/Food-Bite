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

part of 'setting_section_bloc.dart';

enum SettingSectionStatus { initial, failure }

extension SettingSectionStatusX on SettingSectionStatus {
  bool get isInitial => this == SettingSectionStatus.initial;
  bool get isFailure => this == SettingSectionStatus.failure;
}

final class SettingSectionState {
  final String currentVersion;
  final SettingSectionStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const SettingSectionState({this.currentVersion = '', this.status = SettingSectionStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  SettingSectionState copyWith({String? currentVersion, SettingSectionStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return SettingSectionState(
      currentVersion: currentVersion ?? this.currentVersion,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
