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

part of 'firebase_verification_modal_bloc.dart';

enum FirebaseVerificationModalStatus { sending, sent, sentFailed, verifying, verified, verifyFailed }

extension FirebaseVerificationModalStatusX on FirebaseVerificationModalStatus {
  bool get isSending => this == FirebaseVerificationModalStatus.sending;
  bool get isSent => this == FirebaseVerificationModalStatus.sent;
  bool get isSentFailed => this == FirebaseVerificationModalStatus.sentFailed;
  bool get isVerifying => this == FirebaseVerificationModalStatus.verifying;
  bool get isVerified => this == FirebaseVerificationModalStatus.verified;
  bool get isVerifyFailed => this == FirebaseVerificationModalStatus.verifyFailed;
}

final class FirebaseVerificationModalState {
  final String toNumber;
  final String countryCode;
  final String mobileNumber;
  final String verificationId;
  final String smsCode;
  final String accessToken;
  final FirebaseVerificationModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const FirebaseVerificationModalState({
    this.toNumber = '',
    this.countryCode = '',
    this.mobileNumber = '',
    this.verificationId = '',
    this.smsCode = '',
    this.accessToken = '',
    this.status = FirebaseVerificationModalStatus.sending,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  FirebaseVerificationModalState copyWith({
    String? toNumber,
    String? countryCode,
    String? mobileNumber,
    String? verificationId,
    String? smsCode,
    String? accessToken,
    FirebaseVerificationModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return FirebaseVerificationModalState(
      toNumber: toNumber ?? this.toNumber,
      countryCode: countryCode ?? this.countryCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      verificationId: verificationId ?? this.verificationId,
      smsCode: smsCode ?? this.smsCode,
      accessToken: accessToken ?? this.accessToken,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
