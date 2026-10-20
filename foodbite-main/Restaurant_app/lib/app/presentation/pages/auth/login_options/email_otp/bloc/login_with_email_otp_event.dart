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

part of 'login_with_email_otp_bloc.dart';

sealed class LoginWithEmailOtpEvent {}

final class LoginWithEmailOtpInitialEvent extends LoginWithEmailOtpEvent {}

final class LoginWithEmailOtpChangedEvent extends LoginWithEmailOtpEvent {
  final String email;
  LoginWithEmailOtpChangedEvent({required this.email});
}

final class LoginWithEmailOtpUnfocusedEvent extends LoginWithEmailOtpEvent {}

final class LoginWithEmailOtpRememberChangedEvent extends LoginWithEmailOtpEvent {
  final bool checked;
  LoginWithEmailOtpRememberChangedEvent({required this.checked});
}

final class LoginWithEmailOtpFormSubmitEvent extends LoginWithEmailOtpEvent {}

final class LoginWithEmailOtpLoginNowEvent extends LoginWithEmailOtpEvent {
  final String otp;
  LoginWithEmailOtpLoginNowEvent({required this.otp});
}

final class LoginWithEmailOtpGoogleAccountEvent extends LoginWithEmailOtpEvent {}

final class LoginWithEmailOtpFacebookAccountEvent extends LoginWithEmailOtpEvent {}

final class LoginWithGoogleLoginFailedEvent extends LoginWithEmailOtpEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends LoginWithEmailOtpEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
