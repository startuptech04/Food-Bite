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

enum WalletStatus { loading, success, failure, empty, unAuthorized, loadMoreError }

extension WalletStatusX on WalletStatus {
  bool get isLoading => this == WalletStatus.loading;
  bool get isSuccess => this == WalletStatus.success;
  bool get isFailure => this == WalletStatus.failure;
  bool get isEmpty => this == WalletStatus.empty;
  bool get isUnAuthorized => this == WalletStatus.unAuthorized;
  bool get isLoadMoreError => this == WalletStatus.loadMoreError;
}

final class WalletState {
  final WalletInfoModel wallet;
  final String toggleTransaction;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final bool isAuthorized;
  final WalletStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const WalletState({
    required this.wallet,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.isAuthorized = false,
    this.toggleTransaction = '',
    this.status = WalletStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  WalletState copyWith({WalletInfoModel? wallet, String? toggleTransaction, int? pageSize, int? currentPage, bool? loadMore, bool? isAuthorized, WalletStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      toggleTransaction: toggleTransaction ?? this.toggleTransaction,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      isAuthorized: isAuthorized ?? this.isAuthorized,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
