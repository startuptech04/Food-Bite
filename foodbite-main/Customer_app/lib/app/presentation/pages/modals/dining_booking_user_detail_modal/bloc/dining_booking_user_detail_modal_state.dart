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

part of 'dining_booking_user_detail_modal_bloc.dart';

final class DiningBookingUserDetailModalState {
  final DiningBookingEmailField userEmail;
  final DiningBookingNameField userName;
  final DiningBookingCountryCodeField userCountryCode;
  final String flag;
  final DiningBookingNumberField userContact;
  final bool isValid;
  final FormzSubmissionStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningBookingUserDetailModalState({
    this.userEmail = const DiningBookingEmailField.pure(),
    this.userName = const DiningBookingNameField.pure(),
    this.userCountryCode = const DiningBookingCountryCodeField.pure(),
    this.flag = '',
    this.userContact = const DiningBookingNumberField.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.inProgress,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DiningBookingUserDetailModalState copyWith({
    DiningBookingEmailField? userEmail,
    DiningBookingNameField? userName,
    DiningBookingCountryCodeField? userCountryCode,
    String? flag,
    DiningBookingNumberField? userContact,
    bool? isValid,
    FormzSubmissionStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DiningBookingUserDetailModalState(
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userCountryCode: userCountryCode ?? this.userCountryCode,
      flag: flag ?? this.flag,
      userContact: userContact ?? this.userContact,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
