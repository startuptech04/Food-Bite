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

part of 'dining_booking_refund_reason_list_modal_bloc.dart';

enum DiningBookingRefundReasonListModalStatus { loading, success, failure, empty }

extension DiningBookingRefundReasonListModalStatusX on DiningBookingRefundReasonListModalStatus {
  bool get isLoading => this == DiningBookingRefundReasonListModalStatus.loading;
  bool get isSuccess => this == DiningBookingRefundReasonListModalStatus.success;
  bool get isFailure => this == DiningBookingRefundReasonListModalStatus.failure;
  bool get isEmpty => this == DiningBookingRefundReasonListModalStatus.empty;
}

final class DiningBookingRefundReasonListModalState {
  final DiningBookingRefundReasonListModel list;
  final String reasonId;
  final DiningBookingRefundReasonListModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningBookingRefundReasonListModalState({required this.list, this.reasonId = '', this.status = DiningBookingRefundReasonListModalStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  DiningBookingRefundReasonListModalState copyWith({DiningBookingRefundReasonListModel? list, String? reasonId, DiningBookingRefundReasonListModalStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return DiningBookingRefundReasonListModalState(
      list: list ?? this.list,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
