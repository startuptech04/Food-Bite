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

part of 'web_otp_modal_bloc.dart';

sealed class WebOtpModalEvent {}

final class WebOtpModalInitialEvent extends WebOtpModalEvent {
  final String otpId;
  final String locale;
  WebOtpModalInitialEvent({required this.otpId, required this.locale});
}

final class WebOtpModalResponseEvent extends WebOtpModalEvent {
  final bool isSuccess;
  final String dummyOTP;
  WebOtpModalResponseEvent({required this.isSuccess, required this.dummyOTP});
}
