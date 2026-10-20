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

part of 'dining_cancellation_reason_modal_bloc.dart';

enum DiningCancellationReasonModalStatus { loading, success, failure, empty }

extension DiningCancellationReasonModalStatusX on DiningCancellationReasonModalStatus {
  bool get isLoading => this == DiningCancellationReasonModalStatus.loading;
  bool get isSuccess => this == DiningCancellationReasonModalStatus.success;
  bool get isFailure => this == DiningCancellationReasonModalStatus.failure;
  bool get isEmpty => this == DiningCancellationReasonModalStatus.empty;
}

final class DiningCancellationReasonModalState {
  final DiningBookingCancellationReasonListModel model;
  final String reasonId;
  final DiningCancellationReasonModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DiningCancellationReasonModalState({required this.model, this.reasonId = '', this.status = DiningCancellationReasonModalStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  DiningCancellationReasonModalState copyWith({DiningBookingCancellationReasonListModel? model, String? reasonId, DiningCancellationReasonModalStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return DiningCancellationReasonModalState(
      model: model ?? this.model,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
