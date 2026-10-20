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

part of 'feedback_form_bloc.dart';

enum FeedbackFormStatus { initial, submit, success, failure }

extension FeedbackFormStatusX on FeedbackFormStatus {
  bool get isInitial => this == FeedbackFormStatus.initial;
  bool get isSuccess => this == FeedbackFormStatus.success;
  bool get isSubmit => this == FeedbackFormStatus.submit;
  bool get isFailure => this == FeedbackFormStatus.failure;
}

final class FeedbackFormState {
  final FeedbackFormEmailField userEmail;
  final FeedbackFormNameField userName;
  final FeedbackFormCountryCodeField userCountryCode;
  final String flag;
  final FeedbackFormNumberField userContact;
  final FeedbackFormShortDescriptionField shortDescritpion;
  final bool isValid;
  final FeedbackFormStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FeedbackFormState({
    this.userEmail = const FeedbackFormEmailField.pure(),
    this.userName = const FeedbackFormNameField.pure(),
    this.userCountryCode = const FeedbackFormCountryCodeField.pure(),
    this.flag = '',
    this.userContact = const FeedbackFormNumberField.pure(),
    this.shortDescritpion = const FeedbackFormShortDescriptionField.pure(),
    this.isValid = false,
    this.status = FeedbackFormStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  FeedbackFormState copyWith({
    FeedbackFormEmailField? userEmail,
    FeedbackFormNameField? userName,
    FeedbackFormCountryCodeField? userCountryCode,
    String? flag,
    FeedbackFormNumberField? userContact,
    FeedbackFormShortDescriptionField? shortDescritpion,
    bool? isValid,
    FeedbackFormStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return FeedbackFormState(
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userCountryCode: userCountryCode ?? this.userCountryCode,
      flag: flag ?? this.flag,
      userContact: userContact ?? this.userContact,
      shortDescritpion: shortDescritpion ?? this.shortDescritpion,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
