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

enum LoginWithPhonePasswordStatus { initial, success, failure, inProgress, loaded }

extension LoginWithPhonePasswordStatusX on LoginWithPhonePasswordStatus {
  bool get isInitial => this == LoginWithPhonePasswordStatus.initial;
  bool get isSuccess => this == LoginWithPhonePasswordStatus.success;
  bool get isFailure => this == LoginWithPhonePasswordStatus.failure;
  bool get isInProgress => this == LoginWithPhonePasswordStatus.inProgress;
  bool get isLoaded => this == LoginWithPhonePasswordStatus.loaded;
}

final class LoginWithPhonePasswordState {
  final bool selfRegistration;
  final bool appleSignInEnabled;
  final bool googleSignInEnabled;
  final bool facebookSignInEnabled;
  final LoginWithTypeTwoCountryCodeField countryCode;
  final String flag;
  final LoginWithTypeTwoMobileNumberField mobileNumber;
  final LoginWithTypeTwoPasswordField password;
  final LoginWithTypeTwoRememberMeField remember;
  final bool isValid;
  final bool googleSocialLoginClicked;
  final String googleIdToken;
  final bool facebookSocialLoginClicked;
  final String facebookAccessToken;
  final LoginWithPhonePasswordStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const LoginWithPhonePasswordState({
    this.selfRegistration = false,
    this.appleSignInEnabled = false,
    this.googleSignInEnabled = false,
    this.facebookSignInEnabled = false,
    this.countryCode = const LoginWithTypeTwoCountryCodeField.pure(),
    this.flag = '',
    this.mobileNumber = const LoginWithTypeTwoMobileNumberField.pure(),
    this.password = const LoginWithTypeTwoPasswordField.pure(),
    this.remember = const LoginWithTypeTwoRememberMeField.pure(false),
    this.isValid = false,
    this.googleSocialLoginClicked = false,
    this.googleIdToken = '',
    this.facebookSocialLoginClicked = false,
    this.facebookAccessToken = '',
    this.status = LoginWithPhonePasswordStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  LoginWithPhonePasswordState copyWith({
    bool? selfRegistration,
    bool? appleSignInEnabled,
    bool? googleSignInEnabled,
    bool? facebookSignInEnabled,
    LoginWithTypeTwoCountryCodeField? countryCode,
    String? flag,
    LoginWithTypeTwoMobileNumberField? mobileNumber,
    LoginWithTypeTwoPasswordField? password,
    LoginWithTypeTwoRememberMeField? remember,
    bool? isValid,
    bool? googleSocialLoginClicked,
    String? googleIdToken,
    bool? facebookSocialLoginClicked,
    String? facebookAccessToken,
    LoginWithPhonePasswordStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return LoginWithPhonePasswordState(
      selfRegistration: selfRegistration ?? this.selfRegistration,
      appleSignInEnabled: appleSignInEnabled ?? this.appleSignInEnabled,
      googleSignInEnabled: googleSignInEnabled ?? this.googleSignInEnabled,
      facebookSignInEnabled: facebookSignInEnabled ?? this.facebookSignInEnabled,
      countryCode: countryCode ?? this.countryCode,
      flag: flag ?? this.flag,
      mobileNumber: mobileNumber ?? this.mobileNumber,
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
