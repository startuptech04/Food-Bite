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

part of 'reset_with_email_otp_bloc.dart';

sealed class ResetWithEmailOtpEvent {}

final class ResetWithEmailOtpInitialEvent extends ResetWithEmailOtpEvent {}

final class ResetWithOptionOneEmailChangedEvent extends ResetWithEmailOtpEvent {
  final String email;
  ResetWithOptionOneEmailChangedEvent({required this.email});
}

final class ResetWithOptionOneEmailUnfocusedEvent extends ResetWithEmailOtpEvent {}

final class ResetWithOptionOneSendVerificationMailEvent extends ResetWithEmailOtpEvent {}

final class ResetWithOptionOneVerificationSuccessEvent extends ResetWithEmailOtpEvent {}

final class ResetWithOptionOnePasswordChangedEvent extends ResetWithEmailOtpEvent {
  final String password;

  ResetWithOptionOnePasswordChangedEvent({required this.password});
}

final class ResetWithOptionOnePasswordUnfocusedEvent extends ResetWithEmailOtpEvent {}

final class ResetWithOptionOneConfirmPasswordChangedEvent extends ResetWithEmailOtpEvent {
  final String password;

  ResetWithOptionOneConfirmPasswordChangedEvent({required this.password});
}

final class ResetWithOptionOneConfirmPasswordUnfocusedEvent extends ResetWithEmailOtpEvent {}

final class ResetWithOptionOneUpdatePasswordEvent extends ResetWithEmailOtpEvent {}
