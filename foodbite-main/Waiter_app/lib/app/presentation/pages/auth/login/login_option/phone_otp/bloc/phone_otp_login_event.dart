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

part of 'phone_otp_login_bloc.dart';

sealed class PhoneOtpLoginEvent {}

final class PhoneOtpLoginInitialEvent extends PhoneOtpLoginEvent {}

final class PhoneOtpCountryCodeChangedEvent extends PhoneOtpLoginEvent {
  final String countryCode;
  PhoneOtpCountryCodeChangedEvent({required this.countryCode});
}

final class PhoneOtpCountryCodeUnfocusedEvent extends PhoneOtpLoginEvent {}

final class PhoneOtpMobileNumberChangedEvent extends PhoneOtpLoginEvent {
  final String mobileNumber;
  PhoneOtpMobileNumberChangedEvent({required this.mobileNumber});
}

final class PhoneOtpMobileNumberUnfocusedEvent extends PhoneOtpLoginEvent {}

final class PhoneOtpRememberChangedEvent extends PhoneOtpLoginEvent {
  final bool checked;
  PhoneOtpRememberChangedEvent({required this.checked});
}

final class PhoneOtpFormSubmittedEvent extends PhoneOtpLoginEvent {}

final class PhoneOtpLoginNowEvent extends PhoneOtpLoginEvent {}

final class PhoneOtpFirebaseVerificationEvent extends PhoneOtpLoginEvent {
  final String accessToken;
  PhoneOtpFirebaseVerificationEvent({required this.accessToken});
}

final class LoginWithGoogleAccountEvent extends PhoneOtpLoginEvent {}

final class LoginWithFacebookAccountEvent extends PhoneOtpLoginEvent {}

final class LoginWithGoogleLoginFailedEvent extends PhoneOtpLoginEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends PhoneOtpLoginEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
