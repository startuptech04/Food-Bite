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

part of 'tiffin_subscription_refund_reason_list_modal_bloc.dart';

enum TiffinSubscriptionRefundReasonListModalStatus { loading, success, failure, empty }

extension TiffinSubscriptionRefundReasonListModalStatusX on TiffinSubscriptionRefundReasonListModalStatus {
  bool get isLoading => this == TiffinSubscriptionRefundReasonListModalStatus.loading;
  bool get isSuccess => this == TiffinSubscriptionRefundReasonListModalStatus.success;
  bool get isFailure => this == TiffinSubscriptionRefundReasonListModalStatus.failure;
  bool get isEmpty => this == TiffinSubscriptionRefundReasonListModalStatus.empty;
}

final class TiffinSubscriptionRefundReasonListModalState {
  final TiffinSubscriptionRefundReasonListModel list;
  final String reasonId;
  final TiffinSubscriptionRefundReasonListModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const TiffinSubscriptionRefundReasonListModalState({
    required this.list,
    this.reasonId = '',
    this.status = TiffinSubscriptionRefundReasonListModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  TiffinSubscriptionRefundReasonListModalState copyWith({
    TiffinSubscriptionRefundReasonListModel? list,
    String? reasonId,
    TiffinSubscriptionRefundReasonListModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return TiffinSubscriptionRefundReasonListModalState(
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
