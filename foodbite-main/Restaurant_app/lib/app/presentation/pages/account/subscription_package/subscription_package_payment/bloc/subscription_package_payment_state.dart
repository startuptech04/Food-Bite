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

part of 'subscription_package_payment_bloc.dart';

enum SubscriptionPackagePaymentStatus { initial, success }

extension SubscriptionPackagePaymentStatusX on SubscriptionPackagePaymentStatus {
  bool get isInitial => this == SubscriptionPackagePaymentStatus.initial;
  bool get isSuccess => this == SubscriptionPackagePaymentStatus.success;
}

final class SubscriptionPackagePaymentState {
  final SubscriptionPackagePaymentStatus status;
  final String alertMessage;
  final String extraMessage;
  const SubscriptionPackagePaymentState({this.status = SubscriptionPackagePaymentStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  SubscriptionPackagePaymentState copyWith({SubscriptionPackagePaymentStatus? status, String? alertMessage, String? extraMessage}) {
    return SubscriptionPackagePaymentState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
