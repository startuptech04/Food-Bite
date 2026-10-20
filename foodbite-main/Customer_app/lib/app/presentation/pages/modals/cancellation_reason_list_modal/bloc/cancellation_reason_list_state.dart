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

part of 'cancellation_reason_list_bloc.dart';

enum CancellationReasonListStatus { loading, success, failure, empty }

extension CancellationReasonListStatusX on CancellationReasonListStatus {
  bool get isLoading => this == CancellationReasonListStatus.loading;
  bool get isSuccess => this == CancellationReasonListStatus.success;
  bool get isFailure => this == CancellationReasonListStatus.failure;
  bool get isEmpty => this == CancellationReasonListStatus.empty;
}

final class CancellationReasonListState {
  final OrderCancellationListModel list;
  final String reasonId;
  final CancellationReasonListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CancellationReasonListState({required this.list, this.reasonId = '', this.status = CancellationReasonListStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  CancellationReasonListState copyWith({OrderCancellationListModel? list, String? reasonId, CancellationReasonListStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return CancellationReasonListState(
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
