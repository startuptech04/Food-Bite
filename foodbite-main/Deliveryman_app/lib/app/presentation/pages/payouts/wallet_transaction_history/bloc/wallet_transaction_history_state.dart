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

part of 'wallet_transaction_history_bloc.dart';

enum WalletTransactionHistoryStatus { loading, success, failure, empty, customError }

extension WalletTransactionHistoryStatusX on WalletTransactionHistoryStatus {
  bool get isLoading => this == WalletTransactionHistoryStatus.loading;
  bool get isSuccess => this == WalletTransactionHistoryStatus.success;
  bool get isFailure => this == WalletTransactionHistoryStatus.failure;
  bool get isEmpty => this == WalletTransactionHistoryStatus.empty;
  bool get isCustomError => this == WalletTransactionHistoryStatus.customError;
}

final class WalletTransactionHistoryState {
  final WalletTransactionListModel model;
  final String toggleTransaction;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final WalletTransactionHistoryStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const WalletTransactionHistoryState({
    required this.model,
    this.toggleTransaction = '',
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = WalletTransactionHistoryStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  WalletTransactionHistoryState copyWith({
    WalletTransactionListModel? model,
    String? toggleTransaction,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    WalletTransactionHistoryStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return WalletTransactionHistoryState(
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
