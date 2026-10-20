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

part of 'account_setting_delete_account_submit_bloc.dart';

enum AccountSettingDeleteAccountSubmitStatus { initial, loading, success, failure }

extension AccountSettingDeleteAccountSubmitStatusX on AccountSettingDeleteAccountSubmitStatus {
  bool get isInitial => this == AccountSettingDeleteAccountSubmitStatus.initial;
  bool get isLoading => this == AccountSettingDeleteAccountSubmitStatus.loading;
  bool get isSuccess => this == AccountSettingDeleteAccountSubmitStatus.success;
  bool get isFailure => this == AccountSettingDeleteAccountSubmitStatus.failure;
}

final class AccountSettingDeleteAccountSubmitState {
  final String reason;
  final AccountSettingDeleteAccountSubmitStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountSettingDeleteAccountSubmitState({this.reason = '', this.status = AccountSettingDeleteAccountSubmitStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  AccountSettingDeleteAccountSubmitState copyWith({String? reason, AccountSettingDeleteAccountSubmitStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return AccountSettingDeleteAccountSubmitState(
      reason: reason ?? this.reason,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
