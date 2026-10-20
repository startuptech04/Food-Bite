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

part of 'report_issue_restaurant_modal_bloc.dart';

enum ReportIssueRestaurantModalStatus { loading, success, failure, empty, inProgress, customError, reportSent }

extension ReportIssueRestaurantModalStatusX on ReportIssueRestaurantModalStatus {
  bool get isLoading => this == ReportIssueRestaurantModalStatus.loading;
  bool get isSuccess => this == ReportIssueRestaurantModalStatus.success;
  bool get isFailure => this == ReportIssueRestaurantModalStatus.failure;
  bool get isEmpty => this == ReportIssueRestaurantModalStatus.empty;
  bool get isInProgress => this == ReportIssueRestaurantModalStatus.inProgress;
  bool get isCustomError => this == ReportIssueRestaurantModalStatus.customError;
  bool get isReportSent => this == ReportIssueRestaurantModalStatus.reportSent;
}

final class ReportIssueRestaurantModalState {
  final ReportIssueRestaurantReasonListModel list;
  final String restaurant;
  final String reasonId;
  final String reasonName;
  final bool issueSelected;
  final bool isValid;
  final ReportIssueRestaurantMessageField message;
  final ReportIssueRestaurantModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const ReportIssueRestaurantModalState({
    required this.list,
    this.restaurant = '',
    this.reasonId = '',
    this.reasonName = '',
    this.issueSelected = false,
    this.isValid = false,
    this.message = const ReportIssueRestaurantMessageField.pure(),
    this.status = ReportIssueRestaurantModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  ReportIssueRestaurantModalState copyWith({
    ReportIssueRestaurantReasonListModel? list,
    String? restaurant,
    String? reasonId,
    String? reasonName,
    bool? issueSelected,
    bool? isValid,
    ReportIssueRestaurantMessageField? message,
    ReportIssueRestaurantModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return ReportIssueRestaurantModalState(
      message: message ?? this.message,
      list: list ?? this.list,
      restaurant: restaurant ?? this.restaurant,
      reasonId: reasonId ?? this.reasonId,
      reasonName: reasonName ?? this.reasonName,
      issueSelected: issueSelected ?? this.issueSelected,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
