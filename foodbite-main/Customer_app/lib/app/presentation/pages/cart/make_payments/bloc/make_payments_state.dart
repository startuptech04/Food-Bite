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

part of 'make_payments_bloc.dart';

enum MakePaymentStatus { initial, success }

extension MakePaymentStatusX on MakePaymentStatus {
  bool get isInitial => this == MakePaymentStatus.initial;
  bool get isSuccess => this == MakePaymentStatus.success;
}

final class MakePaymentsState {
  final MakePaymentStatus status;
  final String alertMessage;
  final String extraMessage;
  const MakePaymentsState({this.status = MakePaymentStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  MakePaymentsState copyWith({MakePaymentStatus? status, String? alertMessage, String? extraMessage}) {
    return MakePaymentsState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
