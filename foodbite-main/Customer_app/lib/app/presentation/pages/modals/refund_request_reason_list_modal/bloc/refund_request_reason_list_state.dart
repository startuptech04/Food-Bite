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

part of 'refund_request_reason_list_bloc.dart';

enum RefundRequestReasonListStatus { loading, success, failure, empty }

extension RefundRequestReasonListStatusX on RefundRequestReasonListStatus {
  bool get isLoading => this == RefundRequestReasonListStatus.loading;
  bool get isSuccess => this == RefundRequestReasonListStatus.success;
  bool get isFailure => this == RefundRequestReasonListStatus.failure;
  bool get isEmpty => this == RefundRequestReasonListStatus.empty;
}

final class RefundRequestReasonListState {
  final RefundRequestListModel list;
  final String reasonId;
  final RefundRequestReasonListStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const RefundRequestReasonListState({required this.list, this.reasonId = '', this.status = RefundRequestReasonListStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  RefundRequestReasonListState copyWith({RefundRequestListModel? list, String? reasonId, RefundRequestReasonListStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return RefundRequestReasonListState(
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
