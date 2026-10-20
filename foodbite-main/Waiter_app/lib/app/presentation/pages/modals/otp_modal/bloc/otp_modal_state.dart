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

enum OtpModalStatus { initial, inProgress, success, failure, resend, successResent }

extension OtpModalStatusX on OtpModalStatus {
  bool get isInitial => this == OtpModalStatus.initial;
  bool get isSuccess => this == OtpModalStatus.success;
  bool get isFailure => this == OtpModalStatus.failure;
  bool get isResend => this == OtpModalStatus.resend;
  bool get isInProgress => this == OtpModalStatus.inProgress;
  bool get isSuccessResent => this == OtpModalStatus.successResent;
}

final class OtpModalState {
  final String id;
  final String provider;
  final String otp;
  final OtpModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const OtpModalState({this.id = '', this.provider = '', this.otp = '', this.status = OtpModalStatus.initial, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  OtpModalState copyWith({String? id, String? provider, String? otp, OtpModalStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return OtpModalState(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      otp: otp ?? this.otp,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
