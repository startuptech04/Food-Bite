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

part of 'tiffin_subscription_cancellation_reason_list_modal_bloc.dart';

enum TiffinSubscriptionCancellationReasonListModalStatus { loading, success, failure, empty }

extension TiffinSubscriptionCancellationReasonListModalStatusX on TiffinSubscriptionCancellationReasonListModalStatus {
  bool get isLoading => this == TiffinSubscriptionCancellationReasonListModalStatus.loading;
  bool get isSuccess => this == TiffinSubscriptionCancellationReasonListModalStatus.success;
  bool get isFailure => this == TiffinSubscriptionCancellationReasonListModalStatus.failure;
  bool get isEmpty => this == TiffinSubscriptionCancellationReasonListModalStatus.empty;
}

final class TiffinSubscriptionCancellationReasonListModalState {
  final TiffinSubscriptionCancellationReasonListModel list;
  final String reasonId;
  final TiffinSubscriptionCancellationReasonListModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const TiffinSubscriptionCancellationReasonListModalState({
    required this.list,
    this.reasonId = '',
    this.status = TiffinSubscriptionCancellationReasonListModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  TiffinSubscriptionCancellationReasonListModalState copyWith({
    TiffinSubscriptionCancellationReasonListModel? list,
    String? reasonId,
    TiffinSubscriptionCancellationReasonListModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return TiffinSubscriptionCancellationReasonListModalState(
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
