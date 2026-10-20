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

part of 'offline_reasons_bloc.dart';

enum OfflineReasonsStatus { loading, success, failure, empty }

extension OfflineReasonsStatusX on OfflineReasonsStatus {
  bool get isLoading => this == OfflineReasonsStatus.loading;
  bool get isSuccess => this == OfflineReasonsStatus.success;
  bool get isFailure => this == OfflineReasonsStatus.failure;
  bool get isEmpty => this == OfflineReasonsStatus.empty;
}

final class OfflineReasonsState {
  final OfflineMessagesModel reasons;
  final String reasonId;
  final OfflineReasonsStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OfflineReasonsState({required this.reasons, this.reasonId = '', this.status = OfflineReasonsStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OfflineReasonsState copyWith({OfflineMessagesModel? reasons, String? reasonId, OfflineReasonsStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OfflineReasonsState(
      reasons: reasons ?? this.reasons,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
