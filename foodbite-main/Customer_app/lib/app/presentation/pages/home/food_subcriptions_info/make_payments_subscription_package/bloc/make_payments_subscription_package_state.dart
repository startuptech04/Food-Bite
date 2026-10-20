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

part of 'make_payments_subscription_package_bloc.dart';

enum MakePaymentsSubscriptionPackageStatus { initial, success }

extension MakePaymentsSubscriptionPackageStatusX on MakePaymentsSubscriptionPackageStatus {
  bool get isInitial => this == MakePaymentsSubscriptionPackageStatus.initial;
  bool get isSuccess => this == MakePaymentsSubscriptionPackageStatus.success;
}

final class MakePaymentsSubscriptionPackageState {
  final MakePaymentsSubscriptionPackageStatus status;
  final String alertMessage;
  final String extraMessage;
  const MakePaymentsSubscriptionPackageState({this.status = MakePaymentsSubscriptionPackageStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  MakePaymentsSubscriptionPackageState copyWith({MakePaymentsSubscriptionPackageStatus? status, String? alertMessage, String? extraMessage}) {
    return MakePaymentsSubscriptionPackageState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
