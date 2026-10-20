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

part of 'reset_password_bloc.dart';

enum ResetPasswordStatus { initial, success }

extension ResetPasswordStatusX on ResetPasswordStatus {
  bool get isInitial => this == ResetPasswordStatus.initial;
  bool get isSuccess => this == ResetPasswordStatus.success;
}

final class ResetPasswordState {
  final String userResetPasswordWith;
  final ResetPasswordStatus status;
  final String alertMessage;
  final String extraMessage;
  const ResetPasswordState({this.userResetPasswordWith = '', this.status = ResetPasswordStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  ResetPasswordState copyWith({String? userResetPasswordWith, ResetPasswordStatus? status, String? alertMessage, String? extraMessage}) {
    return ResetPasswordState(
      userResetPasswordWith: userResetPasswordWith ?? this.userResetPasswordWith,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
