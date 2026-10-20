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

part of 'account_setting_change_email_bloc.dart';

enum AccountSettingChangeEmailStatus { initial, success, failure, inProgress, loaded, verify }

extension AccountSettingChangeEmailStatusX on AccountSettingChangeEmailStatus {
  bool get isInitial => this == AccountSettingChangeEmailStatus.initial;
  bool get isSuccess => this == AccountSettingChangeEmailStatus.success;
  bool get isFailure => this == AccountSettingChangeEmailStatus.failure;
  bool get isInProgress => this == AccountSettingChangeEmailStatus.inProgress;
  bool get isLoaded => this == AccountSettingChangeEmailStatus.loaded;
  bool get isVerify => this == AccountSettingChangeEmailStatus.verify;
}

final class AccountSettingChangeEmailState {
  final String userEmail;
  final AccountSettingChangeEmailField email;
  final AccountSettingUpdateEmailResponseModel verification;
  final String locale;
  final bool isValid;
  final AccountSettingChangeEmailStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountSettingChangeEmailState({
    this.userEmail = '',
    this.email = const AccountSettingChangeEmailField.pure(),
    required this.verification,
    this.locale = '',
    this.isValid = false,
    this.status = AccountSettingChangeEmailStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  AccountSettingChangeEmailState copyWith({
    String? userEmail,
    AccountSettingChangeEmailField? email,
    String? locale,
    AccountSettingUpdateEmailResponseModel? verification,
    bool? isValid,
    AccountSettingChangeEmailStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return AccountSettingChangeEmailState(
      userEmail: userEmail ?? this.userEmail,
      email: email ?? this.email,
      verification: verification ?? this.verification,
      locale: locale ?? this.locale,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
