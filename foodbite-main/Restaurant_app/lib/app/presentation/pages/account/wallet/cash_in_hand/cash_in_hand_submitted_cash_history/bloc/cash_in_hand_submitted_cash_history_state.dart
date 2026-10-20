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

part of 'cash_in_hand_submitted_cash_history_bloc.dart';

enum CashInHandSubmittedCashHistoryStatus { loading, success, failure, empty, customError }

extension CashInHandSubmittedCashHistoryStatusX on CashInHandSubmittedCashHistoryStatus {
  bool get isLoading => this == CashInHandSubmittedCashHistoryStatus.loading;
  bool get isSuccess => this == CashInHandSubmittedCashHistoryStatus.success;
  bool get isFailure => this == CashInHandSubmittedCashHistoryStatus.failure;
  bool get isEmpty => this == CashInHandSubmittedCashHistoryStatus.empty;
  bool get isCustomError => this == CashInHandSubmittedCashHistoryStatus.customError;
}

final class CashInHandSubmittedCashHistoryState {
  final SubmittedCashInHandHistoryListModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final CashInHandSubmittedCashHistoryStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CashInHandSubmittedCashHistoryState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = CashInHandSubmittedCashHistoryStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  CashInHandSubmittedCashHistoryState copyWith({
    SubmittedCashInHandHistoryListModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    CashInHandSubmittedCashHistoryStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return CashInHandSubmittedCashHistoryState(
      model: model ?? this.model,
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
