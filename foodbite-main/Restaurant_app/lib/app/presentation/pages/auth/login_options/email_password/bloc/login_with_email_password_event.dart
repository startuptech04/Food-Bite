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

part of 'login_with_email_password_bloc.dart';

sealed class LoginWithEmailPasswordEvent {}

final class LoginWithEmailPasswordInitialEvent extends LoginWithEmailPasswordEvent {}

final class LoginEmailChangedEvent extends LoginWithEmailPasswordEvent {
  final String email;
  LoginEmailChangedEvent({required this.email});
}

final class LoginEmailUnfocusedEvent extends LoginWithEmailPasswordEvent {}

final class LoginPasswordChangedEvent extends LoginWithEmailPasswordEvent {
  final String password;
  LoginPasswordChangedEvent({required this.password});
}

final class LoginRememberChangedEvent extends LoginWithEmailPasswordEvent {
  final bool checked;
  LoginRememberChangedEvent({required this.checked});
}

final class LoginPasswordUnfocusedEvent extends LoginWithEmailPasswordEvent {}

final class LoginFormSubmitEvent extends LoginWithEmailPasswordEvent {}

final class LoginWithGoogleAccountEvent extends LoginWithEmailPasswordEvent {}

final class LoginWithFacebookAccountEvent extends LoginWithEmailPasswordEvent {}

final class LoginWithGoogleLoginFailedEvent extends LoginWithEmailPasswordEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends LoginWithEmailPasswordEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
