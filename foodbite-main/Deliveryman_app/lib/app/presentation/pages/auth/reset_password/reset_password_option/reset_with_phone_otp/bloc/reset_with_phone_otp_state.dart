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

part of 'reset_with_phone_otp_bloc.dart';

enum ResetWithPhoneOtpStatus { initial, loaded, failure, success, inProgress, verify, verifyWeb, verifyFirebase }

extension ResetWithPhoneOtpStatusX on ResetWithPhoneOtpStatus {
  bool get isInitial => this == ResetWithPhoneOtpStatus.initial;
  bool get isLoaded => this == ResetWithPhoneOtpStatus.loaded;
  bool get isFailure => this == ResetWithPhoneOtpStatus.failure;
  bool get isSuccess => this == ResetWithPhoneOtpStatus.success;
  bool get isInProgress => this == ResetWithPhoneOtpStatus.inProgress;
  bool get isVerify => this == ResetWithPhoneOtpStatus.verify;
  bool get isVerifyWeb => this == ResetWithPhoneOtpStatus.verifyWeb;
  bool get isVerifyFirebase => this == ResetWithPhoneOtpStatus.verifyFirebase;
}

final class ResetWithPhoneOtpState {
  final String flag;
  final ResetWithOptionTwoCountryCodeField countryCode;
  final ResetWithOptionTwoMobileNumberField mobileNumber;
  final bool isVerified;
  final String firebaseAccessToken;
  final ResetWithOptionTwoPasswordField password;
  final ResetWithOptionTwoConfirmedPasswordField confirmedPassword;
  final ForgotPasswordResponseModel verification;
  final bool isPhoneValid;
  final bool isPasswordValid;
  final String locale;
  final ResetWithPhoneOtpStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const ResetWithPhoneOtpState({
    this.flag = '',
    this.countryCode = const ResetWithOptionTwoCountryCodeField.pure(),
    this.mobileNumber = const ResetWithOptionTwoMobileNumberField.pure(),
    required this.verification,
    this.isVerified = false,
    this.firebaseAccessToken = '',
    this.password = const ResetWithOptionTwoPasswordField.pure(),
    this.confirmedPassword = const ResetWithOptionTwoConfirmedPasswordField.pure(),
    this.isPhoneValid = false,
    this.isPasswordValid = false,
    this.locale = '',
    this.status = ResetWithPhoneOtpStatus.initial,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  ResetWithPhoneOtpState copyWith({
    String? flag,
    ResetWithOptionTwoCountryCodeField? countryCode,
    ResetWithOptionTwoMobileNumberField? mobileNumber,
    ForgotPasswordResponseModel? verification,
    bool? isVerified,
    String? firebaseAccessToken,
    ResetWithOptionTwoPasswordField? password,
    ResetWithOptionTwoConfirmedPasswordField? confirmedPassword,
    bool? isPhoneValid,
    bool? isPasswordValid,
    String? locale,
    ResetWithPhoneOtpStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return ResetWithPhoneOtpState(
      flag: flag ?? this.flag,
      countryCode: countryCode ?? this.countryCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      verification: verification ?? this.verification,
      isVerified: isVerified ?? this.isVerified,
      firebaseAccessToken: firebaseAccessToken ?? this.firebaseAccessToken,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
