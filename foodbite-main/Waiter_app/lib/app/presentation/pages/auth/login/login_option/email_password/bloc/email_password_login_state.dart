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

enum LoginWithEmailPasswordStatus { initial, success, failure, inProgress }

extension LoginWithEmailPasswordStatusX on LoginWithEmailPasswordStatus {
  bool get isInitial => this == LoginWithEmailPasswordStatus.initial;
  bool get isSuccess => this == LoginWithEmailPasswordStatus.success;
  bool get isFailure => this == LoginWithEmailPasswordStatus.failure;
  bool get isInProgress => this == LoginWithEmailPasswordStatus.inProgress;
}

final class EmailPasswordLoginState {
  final bool appleSignInEnabled;
  final bool googleSignInEnabled;
  final bool facebookSignInEnabled;
  final LoginWithTypeOneEmailField email;
  final LoginWithTypeOnePasswordField password;
  final LoginWithTypeOneRememberMeField remember;
  final bool isValid;
  final bool googleSocialLoginClicked;
  final String googleIdToken;
  final bool facebookSocialLoginClicked;
  final String facebookAccessToken;
  final LoginWithEmailPasswordStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const EmailPasswordLoginState({
    this.appleSignInEnabled = false,
    this.googleSignInEnabled = false,
    this.facebookSignInEnabled = false,
    this.email = const LoginWithTypeOneEmailField.pure(),
    this.password = const LoginWithTypeOnePasswordField.pure(),
    this.remember = const LoginWithTypeOneRememberMeField.pure(false),
    this.isValid = false,
    this.googleSocialLoginClicked = false,
    this.googleIdToken = '',
    this.facebookSocialLoginClicked = false,
    this.facebookAccessToken = '',
    this.status = LoginWithEmailPasswordStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  EmailPasswordLoginState copyWith({
    bool? appleSignInEnabled,
    bool? googleSignInEnabled,
    bool? facebookSignInEnabled,
    LoginWithTypeOneEmailField? email,
    LoginWithTypeOnePasswordField? password,
    LoginWithTypeOneRememberMeField? remember,
    bool? isValid,
    bool? googleSocialLoginClicked,
    String? googleIdToken,
    bool? facebookSocialLoginClicked,
    String? facebookAccessToken,
    LoginWithEmailPasswordStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return EmailPasswordLoginState(
      appleSignInEnabled: appleSignInEnabled ?? this.appleSignInEnabled,
      googleSignInEnabled: googleSignInEnabled ?? this.googleSignInEnabled,
      facebookSignInEnabled: facebookSignInEnabled ?? this.facebookSignInEnabled,
      email: email ?? this.email,
      password: password ?? this.password,
      remember: remember ?? this.remember,
      isValid: isValid ?? this.isValid,
      googleSocialLoginClicked: googleSocialLoginClicked ?? this.googleSocialLoginClicked,
      googleIdToken: googleIdToken ?? this.googleIdToken,
      facebookSocialLoginClicked: facebookSocialLoginClicked ?? this.facebookSocialLoginClicked,
      facebookAccessToken: facebookAccessToken ?? this.facebookAccessToken,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
