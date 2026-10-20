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

part of 'report_emergency_bloc.dart';

enum ReportEmergencyStatus { initial, submit, success, failure }

extension ReportEmergencyStatusX on ReportEmergencyStatus {
  bool get isInitial => this == ReportEmergencyStatus.initial;
  bool get isSuccess => this == ReportEmergencyStatus.success;
  bool get isSubmit => this == ReportEmergencyStatus.submit;
  bool get isFailure => this == ReportEmergencyStatus.failure;
}

final class ReportEmergencyState {
  final List<ReportEmergencyFormSelectModel> query;
  final ReportEmergencyFormSelectModel savedQuery;
  final ReportEmergencyFormEmailField userEmail;
  final ReportEmergencyFormNameField userName;
  final ReportEmergencyFormCountryCodeField userCountryCode;
  final String flag;
  final ReportEmergencyFormNumberField userContact;
  final ReportEmergencyFormShortDescriptionField shortDescritpion;
  final bool isValid;
  final ReportEmergencyStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const ReportEmergencyState({
    this.query = const [],
    required this.savedQuery,
    this.userEmail = const ReportEmergencyFormEmailField.pure(),
    this.userName = const ReportEmergencyFormNameField.pure(),
    this.userCountryCode = const ReportEmergencyFormCountryCodeField.pure(),
    this.flag = '',
    this.userContact = const ReportEmergencyFormNumberField.pure(),
    this.shortDescritpion = const ReportEmergencyFormShortDescriptionField.pure(),
    this.isValid = false,
    this.status = ReportEmergencyStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  ReportEmergencyState copyWith({
    List<ReportEmergencyFormSelectModel>? query,
    ReportEmergencyFormSelectModel? savedQuery,
    ReportEmergencyFormEmailField? userEmail,
    ReportEmergencyFormNameField? userName,
    ReportEmergencyFormCountryCodeField? userCountryCode,
    String? flag,
    ReportEmergencyFormNumberField? userContact,
    ReportEmergencyFormShortDescriptionField? shortDescritpion,
    bool? isValid,
    ReportEmergencyStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return ReportEmergencyState(
      query: query ?? this.query,
      savedQuery: savedQuery ?? this.savedQuery,
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
