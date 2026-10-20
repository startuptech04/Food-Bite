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

part of 'payouts_bloc.dart';

enum PayoutsStatus { loading, success, failure }

extension PayoutsStatusX on PayoutsStatus {
  bool get isLoading => this == PayoutsStatus.loading;
  bool get isSuccess => this == PayoutsStatus.success;
  bool get isFailure => this == PayoutsStatus.failure;
}

final class PayoutsState {
  final PayoutsStatus status;
  final String alertMessage;
  final String extraMessage;
  const PayoutsState({this.status = PayoutsStatus.loading, this.alertMessage = '', this.extraMessage = ''});

  PayoutsState copyWith({PayoutsStatus? status, String? alertMessage, String? extraMessage}) {
    return PayoutsState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
