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

sealed class AccountSettingChangeEmailEvent {}

final class AccountSettingChangeEmailInitialEvent extends AccountSettingChangeEmailEvent {}

final class AccountSettingChangeEmailChangedEvent extends AccountSettingChangeEmailEvent {
  final String email;
  AccountSettingChangeEmailChangedEvent({required this.email});
}

final class AccountSettingChangeEmailUnfocusedEvent extends AccountSettingChangeEmailEvent {}

final class AccountSettingChangeEmailSubmitEvent extends AccountSettingChangeEmailEvent {}

final class AccountSettingChangeEmailVerificationSuccessEvent extends AccountSettingChangeEmailEvent {}
