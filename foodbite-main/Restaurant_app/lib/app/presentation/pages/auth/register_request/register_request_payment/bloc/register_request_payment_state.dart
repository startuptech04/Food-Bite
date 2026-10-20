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

part of 'register_request_payment_bloc.dart';

enum RegisterRequestPaymentStatus { initial, success }

extension RegisterRequestPaymentStatusX on RegisterRequestPaymentStatus {
  bool get isInitial => this == RegisterRequestPaymentStatus.initial;
  bool get isSuccess => this == RegisterRequestPaymentStatus.success;
}

final class RegisterRequestPaymentState {
  final RegisterRequestPaymentStatus status;
  final String alertMessage;
  final String extraMessage;
  const RegisterRequestPaymentState({this.status = RegisterRequestPaymentStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  RegisterRequestPaymentState copyWith({RegisterRequestPaymentStatus? status, String? alertMessage, String? extraMessage}) {
    return RegisterRequestPaymentState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
