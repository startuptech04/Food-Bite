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

enum EmailOtpLoginStatus { initial, success, failure, inProgress, loaded, verify }

extension EmailOtpLoginStatusX on EmailOtpLoginStatus {
  bool get isInitial => this == EmailOtpLoginStatus.initial;
  bool get isSuccess => this == EmailOtpLoginStatus.success;
  bool get isFailure => this == EmailOtpLoginStatus.failure;
  bool get isInProgress => this == EmailOtpLoginStatus.inProgress;
  bool get isLoaded => this == EmailOtpLoginStatus.loaded;
  bool get isVerify => this == EmailOtpLoginStatus.verify;
}

final class EmailOtpLoginState {
  final bool appleSignInEnabled;
  final bool googleSignInEnabled;
  final bool facebookSignInEnabled;
  final LoginWithTypeThreeEmailField email;
  final LoginWithTypeThreeRememberMeField remember;
  final OtpVerificationResponseModel verification;
  final String otpVerification;
  final bool isValid;
  final bool googleSocialLoginClicked;
  final String googleIdToken;
  final bool facebookSocialLoginClicked;
  final String facebookAccessToken;
  final EmailOtpLoginStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const EmailOtpLoginState({
    this.appleSignInEnabled = false,
    this.googleSignInEnabled = false,
    this.facebookSignInEnabled = false,
    this.email = const LoginWithTypeThreeEmailField.pure(),
    this.remember = const LoginWithTypeThreeRememberMeField.pure(false),
    required this.verification,
    this.otpVerification = '',
    this.isValid = false,
    this.googleSocialLoginClicked = false,
    this.googleIdToken = '',
    this.facebookSocialLoginClicked = false,
    this.facebookAccessToken = '',
    this.status = EmailOtpLoginStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  EmailOtpLoginState copyWith({
    bool? appleSignInEnabled,
    bool? googleSignInEnabled,
    bool? facebookSignInEnabled,
    LoginWithTypeThreeEmailField? email,
    LoginWithTypeThreeRememberMeField? remember,
    OtpVerificationResponseModel? verification,
    String? otpVerification,
    bool? isValid,
    bool? googleSocialLoginClicked,
    String? googleIdToken,
    bool? facebookSocialLoginClicked,
    String? facebookAccessToken,
    EmailOtpLoginStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return EmailOtpLoginState(
      appleSignInEnabled: appleSignInEnabled ?? this.appleSignInEnabled,
      googleSignInEnabled: googleSignInEnabled ?? this.googleSignInEnabled,
      facebookSignInEnabled: facebookSignInEnabled ?? this.facebookSignInEnabled,
      email: email ?? this.email,
      remember: remember ?? this.remember,
      verification: verification ?? this.verification,
      otpVerification: otpVerification ?? this.otpVerification,
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
