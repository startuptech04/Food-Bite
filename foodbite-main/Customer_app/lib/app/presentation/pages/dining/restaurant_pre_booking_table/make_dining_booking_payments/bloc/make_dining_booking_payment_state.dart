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

part of 'make_dining_booking_payment_bloc.dart';

enum MakeDiningBookingPaymentStatus { initial, success }

extension MakeDiningBookingPaymentStatusX on MakeDiningBookingPaymentStatus {
  bool get isInitial => this == MakeDiningBookingPaymentStatus.initial;
  bool get isSuccess => this == MakeDiningBookingPaymentStatus.success;
}

final class MakeDiningBookingPaymentState {
  final MakeDiningBookingPaymentStatus status;
  final String alertMessage;
  final String extraMessage;
  const MakeDiningBookingPaymentState({this.status = MakeDiningBookingPaymentStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  MakeDiningBookingPaymentState copyWith({MakeDiningBookingPaymentStatus? status, String? alertMessage, String? extraMessage}) {
    return MakeDiningBookingPaymentState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
