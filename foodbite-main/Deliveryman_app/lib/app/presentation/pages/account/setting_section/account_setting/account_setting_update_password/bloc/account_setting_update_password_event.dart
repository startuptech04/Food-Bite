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

sealed class AccountSettingUpdatePasswordEvent {}

final class AccountSettingUpdatePasswordInitialEvent extends AccountSettingUpdatePasswordEvent {}

final class AccountSettingUpdatePasswordPasswordChangedEvent extends AccountSettingUpdatePasswordEvent {
  final String password;
  AccountSettingUpdatePasswordPasswordChangedEvent({required this.password});
}

final class AccountSettingUpdatePasswordPasswordUnfocusedEvent extends AccountSettingUpdatePasswordEvent {}

final class AccountSettingUpdatePasswordConfirmPasswordChangedEvent extends AccountSettingUpdatePasswordEvent {
  final String password;
  AccountSettingUpdatePasswordConfirmPasswordChangedEvent({required this.password});
}

final class AccountSettingUpdatePasswordConfirmPasswordUnfocusedEvent extends AccountSettingUpdatePasswordEvent {}

final class AccountSettingUpdatePasswordSubmitEvent extends AccountSettingUpdatePasswordEvent {}
