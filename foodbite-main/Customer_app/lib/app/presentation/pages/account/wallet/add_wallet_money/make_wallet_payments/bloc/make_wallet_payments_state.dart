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

part of 'make_wallet_payments_bloc.dart';

enum MakeWalletPaymentsStatus { initial, success }

extension MakeWalletPaymentsStatusX on MakeWalletPaymentsStatus {
  bool get isInitial => this == MakeWalletPaymentsStatus.initial;
  bool get isSuccess => this == MakeWalletPaymentsStatus.success;
}

final class MakeWalletPaymentsState {
  final MakeWalletPaymentsStatus status;
  final String alertMessage;
  final String extraMessage;
  const MakeWalletPaymentsState({this.status = MakeWalletPaymentsStatus.initial, this.alertMessage = '', this.extraMessage = ''});

  MakeWalletPaymentsState copyWith({MakeWalletPaymentsStatus? status, String? alertMessage, String? extraMessage}) {
    return MakeWalletPaymentsState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
