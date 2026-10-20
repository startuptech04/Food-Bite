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

part of 'account_setting_delete_account_bloc.dart';

enum AccountSettingDeleteAccountStatus { loading, success, failure, empty }

extension AccountSettingDeleteAccountStatusX on AccountSettingDeleteAccountStatus {
  bool get isLoading => this == AccountSettingDeleteAccountStatus.loading;
  bool get isSuccess => this == AccountSettingDeleteAccountStatus.success;
  bool get isFailure => this == AccountSettingDeleteAccountStatus.failure;
  bool get isEmpty => this == AccountSettingDeleteAccountStatus.empty;
}

final class AccountSettingDeleteAccountState {
  final AccountSettingDeleteAccountReasonListResponseModel list;
  final AccountSettingDeleteAccountStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AccountSettingDeleteAccountState({required this.list, this.status = AccountSettingDeleteAccountStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  AccountSettingDeleteAccountState copyWith({AccountSettingDeleteAccountReasonListResponseModel? list, AccountSettingDeleteAccountStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return AccountSettingDeleteAccountState(
      list: list ?? this.list,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
