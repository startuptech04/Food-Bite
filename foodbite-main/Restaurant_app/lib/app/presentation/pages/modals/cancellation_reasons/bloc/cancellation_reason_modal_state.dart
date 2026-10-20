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

part of 'cancellation_reason_modal_bloc.dart';

enum CancellationReasonModalStatus { loading, success, failure, empty }

extension CancellationReasonModalStatusX on CancellationReasonModalStatus {
  bool get isLoading => this == CancellationReasonModalStatus.loading;
  bool get isSuccess => this == CancellationReasonModalStatus.success;
  bool get isFailure => this == CancellationReasonModalStatus.failure;
  bool get isEmpty => this == CancellationReasonModalStatus.empty;
}

final class CancellationReasonModalState {
  final OrderCancellationListModel list;
  final String reasonId;
  final CancellationReasonModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CancellationReasonModalState({required this.list, this.reasonId = '', this.status = CancellationReasonModalStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  CancellationReasonModalState copyWith({OrderCancellationListModel? list, String? reasonId, CancellationReasonModalStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return CancellationReasonModalState(
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
