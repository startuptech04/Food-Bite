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

final class LoginWithPhonePasswordCountryCodeChangedEvent extends LoginWithPhonePasswordEvent {
  final String countryCode;
  LoginWithPhonePasswordCountryCodeChangedEvent({required this.countryCode});
}

final class LoginWithPhonePasswordCountryCodeUnfocusedEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithPhonePasswordMobileNumberChangedEvent extends LoginWithPhonePasswordEvent {
  final String mobileNumber;
  LoginWithPhonePasswordMobileNumberChangedEvent({required this.mobileNumber});
}

final class LoginWithPhonePasswordMobileNumberUnfocusedEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithPhonePasswordChangedEvent extends LoginWithPhonePasswordEvent {
  final String password;
  LoginWithPhonePasswordChangedEvent({required this.password});
}

final class LoginWithPhonePasswordUnfocusedEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithPhonePasswordRememberChangedEvent extends LoginWithPhonePasswordEvent {
  final bool checked;
  LoginWithPhonePasswordRememberChangedEvent({required this.checked});
}

final class LoginWithPhonePasswordFormSubmitEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithGoogleAccountEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithFacebookAccountEvent extends LoginWithPhonePasswordEvent {}

final class LoginWithGoogleLoginFailedEvent extends LoginWithPhonePasswordEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends LoginWithPhonePasswordEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
