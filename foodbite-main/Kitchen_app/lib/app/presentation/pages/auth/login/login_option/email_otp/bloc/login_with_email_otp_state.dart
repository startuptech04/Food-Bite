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

enum LoginWithEmailOtpStatus { initial, success, failure, inProgress, loaded, verify }

extension LoginWithEmailOtpStatusX on LoginWithEmailOtpStatus {
  bool get isInitial => this == LoginWithEmailOtpStatus.initial;
  bool get isSuccess => this == LoginWithEmailOtpStatus.success;
  bool get isFailure => this == LoginWithEmailOtpStatus.failure;
  bool get isInProgress => this == LoginWithEmailOtpStatus.inProgress;
  bool get isLoaded => this == LoginWithEmailOtpStatus.loaded;
  bool get isVerify => this == LoginWithEmailOtpStatus.verify;
}

final class LoginWithEmailOtpState {
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
  final LoginWithEmailOtpStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const LoginWithEmailOtpState({
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
    this.status = LoginWithEmailOtpStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  LoginWithEmailOtpState copyWith({
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
    LoginWithEmailOtpStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return LoginWithEmailOtpState(
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
