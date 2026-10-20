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

part of 'phone_password_login_bloc.dart';

sealed class PhonePasswordLoginEvent {}

final class PhonePasswordLoginInitialEvent extends PhonePasswordLoginEvent {}

final class PhonePasswordLoginCountryCodeChangedEvent extends PhonePasswordLoginEvent {
  final String countryCode;
  PhonePasswordLoginCountryCodeChangedEvent({required this.countryCode});
}

final class PhonePasswordLoginCountryCodeUnfocusedEvent extends PhonePasswordLoginEvent {}

final class PhonePasswordLoginMobileNumberChangedEvent extends PhonePasswordLoginEvent {
  final String mobileNumber;
  PhonePasswordLoginMobileNumberChangedEvent({required this.mobileNumber});
}

final class PhonePasswordLoginMobileNumberUnfocusedEvent extends PhonePasswordLoginEvent {}

final class PhonePasswordLoginPasswordChangedEvent extends PhonePasswordLoginEvent {
  final String password;
  PhonePasswordLoginPasswordChangedEvent({required this.password});
}

final class PhonePasswordLoginPasswordUnfocusedEvent extends PhonePasswordLoginEvent {}

final class PhonePasswordLoginRememberChangedEvent extends PhonePasswordLoginEvent {
  final bool checked;
  PhonePasswordLoginRememberChangedEvent({required this.checked});
}

final class PhonePasswordLoginFormSubmitEvent extends PhonePasswordLoginEvent {}

final class LoginWithGoogleAccountEvent extends PhonePasswordLoginEvent {}

final class LoginWithFacebookAccountEvent extends PhonePasswordLoginEvent {}

final class LoginWithGoogleLoginFailedEvent extends PhonePasswordLoginEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends PhonePasswordLoginEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
