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

sealed class ResetWithPhoneOtpEvent {}

final class ResetWithPhoneInitialEvent extends ResetWithPhoneOtpEvent {}

final class ResetWithPhoneTypeTwoCountryCodeChangedEvent extends ResetWithPhoneOtpEvent {
  final String countryCode;
  ResetWithPhoneTypeTwoCountryCodeChangedEvent({required this.countryCode});
}

final class ResetWithPhoneTypeTwoCountryCodeUnfocusedEvent extends ResetWithPhoneOtpEvent {}

final class ResetWithPhoneTypeTwoMobileNumberChangedEvent extends ResetWithPhoneOtpEvent {
  final String mobileNumber;
  ResetWithPhoneTypeTwoMobileNumberChangedEvent({required this.mobileNumber});
}

final class ResetWithPhoneTypeTwoMobileNumberUnfocusedEvent extends ResetWithPhoneOtpEvent {}

final class ResetWithPhoneTypeTwoSendVerificationSMSEvent extends ResetWithPhoneOtpEvent {}

final class ResetWithOptionTwoFirebaseVerificationEvent extends ResetWithPhoneOtpEvent {
  final String accessToken;
  ResetWithOptionTwoFirebaseVerificationEvent({required this.accessToken});
}

final class ResetWithOptionTwoVerificationSuccessEvent extends ResetWithPhoneOtpEvent {}

final class ResetWithOptionTwoPasswordChangedEvent extends ResetWithPhoneOtpEvent {
  final String password;

  ResetWithOptionTwoPasswordChangedEvent({required this.password});
}

final class ResetWithOptionTwoPasswordUnfocusedEvent extends ResetWithPhoneOtpEvent {}

final class ResetWithOptionTwoConfirmPasswordChangedEvent extends ResetWithPhoneOtpEvent {
  final String password;

  ResetWithOptionTwoConfirmPasswordChangedEvent({required this.password});
}

final class ResetWithOptionTwoConfirmPasswordUnfocusedEvent extends ResetWithPhoneOtpEvent {}

final class ResetWithOptionTwoUpdatePasswordEvent extends ResetWithPhoneOtpEvent {}
