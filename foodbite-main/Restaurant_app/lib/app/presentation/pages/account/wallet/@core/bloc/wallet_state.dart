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

part of 'wallet_bloc.dart';

enum WalletStatus { loading, success, failure }

extension WalletStatusX on WalletStatus {
  bool get isLoading => this == WalletStatus.loading;
  bool get isSuccess => this == WalletStatus.success;
  bool get isFailure => this == WalletStatus.failure;
}

final class WalletState {
  final WalletModel model;
  final WalletStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const WalletState({required this.model, this.status = WalletStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  WalletState copyWith({WalletModel? model, WalletStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return WalletState(model: model ?? this.model, status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage, statusCode: statusCode ?? this.statusCode);
  }
}
