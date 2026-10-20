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

enum PhonePasswordLoginStatus { initial, success, failure, inProgress, loaded }

extension PhonePasswordLoginStatusX on PhonePasswordLoginStatus {
  bool get isInitial => this == PhonePasswordLoginStatus.initial;
  bool get isSuccess => this == PhonePasswordLoginStatus.success;
  bool get isFailure => this == PhonePasswordLoginStatus.failure;
  bool get isInProgress => this == PhonePasswordLoginStatus.inProgress;
  bool get isLoaded => this == PhonePasswordLoginStatus.loaded;
}

final class PhonePasswordLoginState {
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
  final PhonePasswordLoginStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PhonePasswordLoginState({
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
    this.status = PhonePasswordLoginStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  PhonePasswordLoginState copyWith({
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
    PhonePasswordLoginStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return PhonePasswordLoginState(
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
