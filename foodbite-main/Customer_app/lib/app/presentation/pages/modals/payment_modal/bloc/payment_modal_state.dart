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

part of 'payment_modal_bloc.dart';

enum PaymentModalStatus { loading, success, failure, selected }

extension PaymentModalStatusX on PaymentModalStatus {
  bool get isLoading => this == PaymentModalStatus.loading;
  bool get isSuccess => this == PaymentModalStatus.success;
  bool get isFailure => this == PaymentModalStatus.failure;
  bool get isSelected => this == PaymentModalStatus.selected;
}

final class PaymentModalState {
  final List<PaymentListModel> paymentList;
  final PaymentModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PaymentModalState({this.paymentList = const [], this.status = PaymentModalStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  PaymentModalState copyWith({List<PaymentListModel>? paymentList, PaymentModalStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return PaymentModalState(
      paymentList: paymentList ?? this.paymentList,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
