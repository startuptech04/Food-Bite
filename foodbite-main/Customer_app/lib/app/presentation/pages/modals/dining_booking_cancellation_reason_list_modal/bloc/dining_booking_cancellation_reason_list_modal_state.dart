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

part of 'dining_booking_cancellation_reason_list_modal_bloc.dart';

enum DiningBookingCancellationReasonListModalStatus { loading, success, failure, empty }

extension DiningBookingCancellationReasonListModalStatusX on DiningBookingCancellationReasonListModalStatus {
  bool get isLoading => this == DiningBookingCancellationReasonListModalStatus.loading;
  bool get isSuccess => this == DiningBookingCancellationReasonListModalStatus.success;
  bool get isFailure => this == DiningBookingCancellationReasonListModalStatus.failure;
  bool get isEmpty => this == DiningBookingCancellationReasonListModalStatus.empty;
}

final class DiningBookingCancellationReasonListModalState {
  final DiningBookingCancellationReasonListModel list;
  final String reasonId;
  final DiningBookingCancellationReasonListModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningBookingCancellationReasonListModalState({
    required this.list,
    this.reasonId = '',
    this.status = DiningBookingCancellationReasonListModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DiningBookingCancellationReasonListModalState copyWith({
    DiningBookingCancellationReasonListModel? list,
    String? reasonId,
    DiningBookingCancellationReasonListModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DiningBookingCancellationReasonListModalState(
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
