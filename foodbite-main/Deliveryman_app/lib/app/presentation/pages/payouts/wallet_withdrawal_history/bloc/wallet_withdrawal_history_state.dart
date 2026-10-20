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

part of 'wallet_withdrawal_history_bloc.dart';

enum WalletWithdrawalHistoryStatus { loading, success, failure, empty, customError }

extension WalletWithdrawalHistoryStatusX on WalletWithdrawalHistoryStatus {
  bool get isLoading => this == WalletWithdrawalHistoryStatus.loading;
  bool get isSuccess => this == WalletWithdrawalHistoryStatus.success;
  bool get isFailure => this == WalletWithdrawalHistoryStatus.failure;
  bool get isEmpty => this == WalletWithdrawalHistoryStatus.empty;
  bool get isCustomError => this == WalletWithdrawalHistoryStatus.customError;
}

final class WalletWithdrawalHistoryState {
  final WithdrawalHistoryModel model;
  final String toggleTransaction;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final WalletWithdrawalHistoryStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const WalletWithdrawalHistoryState({
    required this.model,
    this.toggleTransaction = '',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = WalletWithdrawalHistoryStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  WalletWithdrawalHistoryState copyWith({
    WithdrawalHistoryModel? model,
    String? toggleTransaction,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    WalletWithdrawalHistoryStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return WalletWithdrawalHistoryState(
      model: model ?? this.model,
      toggleTransaction: toggleTransaction ?? this.toggleTransaction,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
