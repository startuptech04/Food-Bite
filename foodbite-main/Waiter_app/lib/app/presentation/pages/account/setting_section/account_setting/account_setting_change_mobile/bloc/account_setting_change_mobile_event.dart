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

part of 'account_setting_change_mobile_bloc.dart';

sealed class AccountSettingChangeMobileEvent {}

final class AccountSettingChangeMobileInitialEvent extends AccountSettingChangeMobileEvent {}

final class AccountSettingChangeMobileCountryCodeChangedEvent extends AccountSettingChangeMobileEvent {
  final String countryCode;
  AccountSettingChangeMobileCountryCodeChangedEvent({required this.countryCode});
}

final class AccountSettingChangeMobileCountryCodeUnfocusedEvent extends AccountSettingChangeMobileEvent {}

final class AccountSettingChangeMobileNumberChangedEvent extends AccountSettingChangeMobileEvent {
  final String mobileNumber;
  AccountSettingChangeMobileNumberChangedEvent({required this.mobileNumber});
}

final class AccountSettingChangeMobileNumberUnfocusedEvent extends AccountSettingChangeMobileEvent {}

final class AccountSettingChangeMobileSubmitEvent extends AccountSettingChangeMobileEvent {}

final class AccountSettingChangeMobileVerificationSuccessEvent extends AccountSettingChangeMobileEvent {}

final class AccountSettingChangeMobileFirebaseVerificationEvent extends AccountSettingChangeMobileEvent {
  final String accessToken;
  AccountSettingChangeMobileFirebaseVerificationEvent({required this.accessToken});
}
