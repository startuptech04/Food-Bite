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

part of 'login_with_phone_password_bloc.dart';

sealed class LoginWithPhonePasswordEvent {}

final class LoginWithPhonePasswordInitialEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithTypeTwoCountryCodeChangedEvent extends LoginWithPhonePasswordEvent {
  final String countryCode;
  LoginWithTypeTwoCountryCodeChangedEvent({required this.countryCode});
}

final class LoginWithTypeTwoCountryCodeUnfocusedEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithTypeTwoMobileNumberChangedEvent extends LoginWithPhonePasswordEvent {
  final String mobileNumber;
  LoginWithTypeTwoMobileNumberChangedEvent({required this.mobileNumber});
}

final class LoginWithTypeTwoMobileNumberUnfocusedEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithTypeTwoPasswordChangedEvent extends LoginWithPhonePasswordEvent {
  final String password;
  LoginWithTypeTwoPasswordChangedEvent({required this.password});
}

final class LoginWithTypeTwoPasswordUnfocusedEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithTypeTwoRememberChangedEvent extends LoginWithPhonePasswordEvent {
  final bool checked;
  LoginWithTypeTwoRememberChangedEvent({required this.checked});
}

final class LoginWithTypeTwoFormSubmittedEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithTypeTwoGoogleAccountEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithTypeTwoFacebookAccountEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithGoogleLoginFailedEvent extends LoginWithPhonePasswordEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends LoginWithPhonePasswordEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
