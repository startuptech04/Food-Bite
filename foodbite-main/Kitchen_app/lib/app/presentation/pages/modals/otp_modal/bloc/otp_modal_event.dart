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

part of 'otp_modal_bloc.dart';

sealed class OtpModalEvent {}

final class OtpModalInitialEvent extends OtpModalEvent {
  final String provider;
  final String providerId;
  final int otpLength;
  final bool canResendOTP;
  OtpModalInitialEvent({required this.provider, required this.providerId, required this.otpLength, required this.canResendOTP});
}

final class OtpModalOnSubmitEvent extends OtpModalEvent {}

final class OtpModalOnResendEvent extends OtpModalEvent {}

final class OtpModalOnOTPChanged extends OtpModalEvent {
  final String otp;
  OtpModalOnOTPChanged({required this.otp});
}
