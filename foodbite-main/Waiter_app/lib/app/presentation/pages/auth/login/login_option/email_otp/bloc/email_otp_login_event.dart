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

part of 'email_otp_login_bloc.dart';

sealed class EmailOtpLoginEvent {}

final class EmailOtpLoginInitialEvent extends EmailOtpLoginEvent {}

final class EmailOtpLoginEmailChangedEvent extends EmailOtpLoginEvent {
  final String email;
  EmailOtpLoginEmailChangedEvent({required this.email});
}

final class EmailOtpLoginEmailUnfocusedEvent extends EmailOtpLoginEvent {}

final class EmailOtpLoginRememberChangedEvent extends EmailOtpLoginEvent {
  final bool checked;
  EmailOtpLoginRememberChangedEvent({required this.checked});
}

final class EmailOtpLoginFormSubmitEvent extends EmailOtpLoginEvent {}

final class EmailOtpLoginLoginNowEvent extends EmailOtpLoginEvent {
  final String otp;
  EmailOtpLoginLoginNowEvent({required this.otp});
}

final class LoginWithGoogleAccountEvent extends EmailOtpLoginEvent {}

final class LoginWithFacebookAccountEvent extends EmailOtpLoginEvent {}

final class LoginWithGoogleLoginFailedEvent extends EmailOtpLoginEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends EmailOtpLoginEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
