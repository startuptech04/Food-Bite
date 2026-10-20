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

part of 'login_with_phone_otp_bloc.dart';

sealed class LoginWithPhoneOtpEvent {}

final class LoginWithPhoneOtpInitialEvent extends LoginWithPhoneOtpEvent {}

final class LoginWithTypeFourCountryCodeChangedEvent extends LoginWithPhoneOtpEvent {
  final String countryCode;
  LoginWithTypeFourCountryCodeChangedEvent({required this.countryCode});
}

final class LoginWithTypeFourCountryCodeUnfocusedEvent extends LoginWithPhoneOtpEvent {}

final class LoginWithTypeFourMobileNumberChangedEvent extends LoginWithPhoneOtpEvent {
  final String mobileNumber;
  LoginWithTypeFourMobileNumberChangedEvent({required this.mobileNumber});
}

final class LoginWithTypeFourMobileNumberUnfocusedEvent extends LoginWithPhoneOtpEvent {}

final class LoginWithTypeFourRememberChangedEvent extends LoginWithPhoneOtpEvent {
  final bool checked;
  LoginWithTypeFourRememberChangedEvent({required this.checked});
}

final class LoginWithTypeFourFormSubmitEvent extends LoginWithPhoneOtpEvent {}

final class LoginWithPhoneOtpLoginNowEvent extends LoginWithPhoneOtpEvent {}

final class LoginWithPhoneOtpFirebaseVerificationEvent extends LoginWithPhoneOtpEvent {
  final String accessToken;
  LoginWithPhoneOtpFirebaseVerificationEvent({required this.accessToken});
}

final class LoginWithPhoneOtpGoogleAccountEvent extends LoginWithPhoneOtpEvent {}

final class LoginWithPhoneOtpRegisterGoogleAccountEvent extends LoginWithPhoneOtpEvent {
  final SocialAccountVerificationModalResponseModel model;
  LoginWithPhoneOtpRegisterGoogleAccountEvent({required this.model});
}

final class LoginWithPhoneOtpFacebookAccountEvent extends LoginWithPhoneOtpEvent {}

final class LoginWithPhoneOtpRegisterFacebookAccountEvent extends LoginWithPhoneOtpEvent {
  final SocialAccountVerificationModalResponseModel model;
  LoginWithPhoneOtpRegisterFacebookAccountEvent({required this.model});
}

final class LoginWithGoogleLoginFailedEvent extends LoginWithPhoneOtpEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends LoginWithPhoneOtpEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
