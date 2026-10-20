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

part of 'phone_otp_login_bloc.dart';

enum PhoneOtpLoginStatus { initial, success, failure, inProgress, loaded, verify, verifyWeb, verifyFirebase }

extension PhoneOtpLoginStatusX on PhoneOtpLoginStatus {
  bool get isInitial => this == PhoneOtpLoginStatus.initial;
  bool get isSuccess => this == PhoneOtpLoginStatus.success;
  bool get isFailure => this == PhoneOtpLoginStatus.failure;
  bool get isInProgress => this == PhoneOtpLoginStatus.inProgress;
  bool get isLoaded => this == PhoneOtpLoginStatus.loaded;
  bool get isVerify => this == PhoneOtpLoginStatus.verify;
  bool get isVerifyWeb => this == PhoneOtpLoginStatus.verifyWeb;
  bool get isVerifyFirebase => this == PhoneOtpLoginStatus.verifyFirebase;
}

final class PhoneOtpLoginState {
  final bool appleSignInEnabled;
  final bool googleSignInEnabled;
  final bool facebookSignInEnabled;
  final LoginWithTypeFourCountryCodeField countryCode;
  final String flag;
  final LoginWithTypeFourMobileNumberField mobileNumber;
  final LoginWithTypeFourRememberMeField remember;
  final LoginWithPhoneOtpVerificationResponseModel verification;
  final String otpVerification;
  final bool isValid;
  final String locale;
  final bool googleSocialLoginClicked;
  final String googleIdToken;
  final bool facebookSocialLoginClicked;
  final String facebookAccessToken;
  final PhoneOtpLoginStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PhoneOtpLoginState({
    this.appleSignInEnabled = false,
    this.googleSignInEnabled = false,
    this.facebookSignInEnabled = false,
    this.countryCode = const LoginWithTypeFourCountryCodeField.pure(),
    this.flag = '',
    this.mobileNumber = const LoginWithTypeFourMobileNumberField.pure(),
    this.remember = const LoginWithTypeFourRememberMeField.pure(false),
    required this.verification,
    this.otpVerification = '',
    this.isValid = false,
    this.locale = 'en',
    this.googleSocialLoginClicked = false,
    this.googleIdToken = '',
    this.facebookSocialLoginClicked = false,
    this.facebookAccessToken = '',
    this.status = PhoneOtpLoginStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  PhoneOtpLoginState copyWith({
    bool? appleSignInEnabled,
    bool? googleSignInEnabled,
    bool? facebookSignInEnabled,
    LoginWithTypeFourCountryCodeField? countryCode,
    String? flag,
    LoginWithTypeFourMobileNumberField? mobileNumber,
    LoginWithTypeFourRememberMeField? remember,
    LoginWithPhoneOtpVerificationResponseModel? verification,
    String? otpVerification,
    bool? isValid,
    String? locale,
    bool? googleSocialLoginClicked,
    String? googleIdToken,
    bool? facebookSocialLoginClicked,
    String? facebookAccessToken,
    PhoneOtpLoginStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return PhoneOtpLoginState(
      appleSignInEnabled: appleSignInEnabled ?? this.appleSignInEnabled,
      googleSignInEnabled: googleSignInEnabled ?? this.googleSignInEnabled,
      facebookSignInEnabled: facebookSignInEnabled ?? this.facebookSignInEnabled,
      countryCode: countryCode ?? this.countryCode,
      flag: flag ?? this.flag,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      verification: verification ?? this.verification,
      otpVerification: otpVerification ?? this.otpVerification,
      remember: remember ?? this.remember,
      isValid: isValid ?? this.isValid,
      locale: locale ?? this.locale,
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
