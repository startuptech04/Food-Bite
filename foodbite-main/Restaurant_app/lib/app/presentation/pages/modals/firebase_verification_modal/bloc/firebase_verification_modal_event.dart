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

sealed class FirebaseVerificationModalEvent {}

final class FirebaseVerificationModalInitialEvent extends FirebaseVerificationModalEvent {
  final String countryCode;
  final String mobileNumber;
  FirebaseVerificationModalInitialEvent({required this.countryCode, required this.mobileNumber});
}

final class FirebaseVerificationModalErrorEvent extends FirebaseVerificationModalEvent {
  final String error;
  FirebaseVerificationModalErrorEvent({required this.error});
}

final class FirebaseVerificationIdEvent extends FirebaseVerificationModalEvent {
  final String id;
  FirebaseVerificationIdEvent({required this.id});
}

final class FirebaseVerificationSMSChangeEvent extends FirebaseVerificationModalEvent {
  final String otp;
  FirebaseVerificationSMSChangeEvent({required this.otp});
}

final class FirebaseVerificationVerifyEvent extends FirebaseVerificationModalEvent {}
