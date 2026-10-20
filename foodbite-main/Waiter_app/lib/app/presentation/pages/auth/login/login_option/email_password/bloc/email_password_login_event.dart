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

part of 'email_password_login_bloc.dart';

sealed class EmailPasswordLoginEvent {}

final class EmailPasswordLoginInitialEvent extends EmailPasswordLoginEvent {}

final class EmailPasswordLoginEmailChangedEvent extends EmailPasswordLoginEvent {
  final String email;
  EmailPasswordLoginEmailChangedEvent({required this.email});
}

final class EmailPasswordLoginEmailUnfocusedEvent extends EmailPasswordLoginEvent {}

final class EmailPasswordLoginPasswordChangedEvent extends EmailPasswordLoginEvent {
  final String password;
  EmailPasswordLoginPasswordChangedEvent({required this.password});
}

final class EmailPasswordLoginPasswordUnfocusedEvent extends EmailPasswordLoginEvent {}

final class EmailPasswordLoginRememberChangedEvent extends EmailPasswordLoginEvent {
  final bool checked;
  EmailPasswordLoginRememberChangedEvent({required this.checked});
}

final class EmailPasswordLoginFormSubmitEvent extends EmailPasswordLoginEvent {}

final class LoginWithGoogleAccountEvent extends EmailPasswordLoginEvent {}

final class LoginWithFacebookAccountEvent extends EmailPasswordLoginEvent {}

final class LoginWithGoogleLoginFailedEvent extends EmailPasswordLoginEvent {
  final String error;
  LoginWithGoogleLoginFailedEvent({required this.error});
}

final class LoginWithGoogleLoginAfterSuccessEvent extends EmailPasswordLoginEvent {
  final String token;
  LoginWithGoogleLoginAfterSuccessEvent({required this.token});
}
