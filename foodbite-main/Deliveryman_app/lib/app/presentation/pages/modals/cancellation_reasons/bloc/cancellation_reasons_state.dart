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

part of 'cancellation_reasons_bloc.dart';

enum CancellationReasonsStatus { loading, success, failure, empty }

extension CancellationReasonsStatusX on CancellationReasonsStatus {
  bool get isLoading => this == CancellationReasonsStatus.loading;
  bool get isSuccess => this == CancellationReasonsStatus.success;
  bool get isFailure => this == CancellationReasonsStatus.failure;
  bool get isEmpty => this == CancellationReasonsStatus.empty;
}

final class CancellationReasonsState {
  final OrderCancellationListModel list;
  final CancellationReasonsStatus status;
  final String reasonId;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const CancellationReasonsState({required this.list, this.status = CancellationReasonsStatus.loading, this.reasonId = '', this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  CancellationReasonsState copyWith({OrderCancellationListModel? list, CancellationReasonsStatus? status, String? reasonId, String? alertMessage, String? extraMessage, int? statusCode}) {
    return CancellationReasonsState(
      list: list ?? this.list,
      status: status ?? this.status,
      reasonId: reasonId ?? this.reasonId,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
