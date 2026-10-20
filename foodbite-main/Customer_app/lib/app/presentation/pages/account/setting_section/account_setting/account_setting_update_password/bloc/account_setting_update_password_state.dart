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

part of 'account_setting_update_password_bloc.dart';

enum AccountSettingUpdatePasswordStatus { initial, failure, success, inProgress, verify }

extension AccountSettingUpdatePasswordStatusX on AccountSettingUpdatePasswordStatus {
  bool get isInitial => this == AccountSettingUpdatePasswordStatus.initial;
  bool get isFailure => this == AccountSettingUpdatePasswordStatus.failure;
  bool get isSuccess => this == AccountSettingUpdatePasswordStatus.success;
  bool get isInProgress => this == AccountSettingUpdatePasswordStatus.inProgress;
  bool get isVerify => this == AccountSettingUpdatePasswordStatus.verify;
}

final class AccountSettingUpdatePasswordState {
  final AccountSettingChangePasswordPasswordField password;
  final AccountSettingChangePasswordConfirmedPasswordField confirmedPassword;
  final bool isPasswordValid;
  final String locale;
  final AccountSettingUpdatePasswordStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountSettingUpdatePasswordState({
    this.password = const AccountSettingChangePasswordPasswordField.pure(),
    this.confirmedPassword = const AccountSettingChangePasswordConfirmedPasswordField.pure(),
    this.isPasswordValid = false,
    this.locale = '',
    this.status = AccountSettingUpdatePasswordStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  AccountSettingUpdatePasswordState copyWith({
    AccountSettingChangePasswordPasswordField? password,
    AccountSettingChangePasswordConfirmedPasswordField? confirmedPassword,
    bool? isPasswordValid,
    String? locale,
    AccountSettingUpdatePasswordStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return AccountSettingUpdatePasswordState(
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
