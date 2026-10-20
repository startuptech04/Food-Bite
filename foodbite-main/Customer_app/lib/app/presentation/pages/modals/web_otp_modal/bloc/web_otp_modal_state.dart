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

enum WebOtpModalStatus { initial, success, failed }

extension WebOtpModalStatusX on WebOtpModalStatus {
  bool get isInitial => this == WebOtpModalStatus.initial;
  bool get isSuccess => this == WebOtpModalStatus.success;
  bool get isFailed => this == WebOtpModalStatus.failed;
}

final class WebOtpModalState {
  final String otpId;
  final String locale;
  final WebOtpModalStatus status;
  final String dummyOTP;
  final String alertMessage;
  final String extraMessage;
  const WebOtpModalState({this.otpId = '', this.locale = '', this.status = WebOtpModalStatus.initial, this.dummyOTP = '', this.alertMessage = '', this.extraMessage = ''});

  WebOtpModalState copyWith({String? otpId, String? locale, WebOtpModalStatus? status, String? dummyOTP, String? alertMessage, String? extraMessage}) {
    return WebOtpModalState(
      otpId: otpId ?? this.otpId,
      locale: locale ?? this.locale,
      status: status ?? this.status,
      dummyOTP: dummyOTP ?? this.dummyOTP,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
