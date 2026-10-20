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

part of 'cash_in_hand_history_bloc.dart';

enum CashInHandHistoryStatus { loading, success, failure, empty, customError }

extension CashInHandHistoryStatusX on CashInHandHistoryStatus {
  bool get isLoading => this == CashInHandHistoryStatus.loading;
  bool get isSuccess => this == CashInHandHistoryStatus.success;
  bool get isFailure => this == CashInHandHistoryStatus.failure;
  bool get isEmpty => this == CashInHandHistoryStatus.empty;
  bool get isCustomError => this == CashInHandHistoryStatus.customError;
}

final class CashInHandHistoryState {
  final CashInHandHistoryListModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final CashInHandHistoryStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CashInHandHistoryState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = CashInHandHistoryStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  CashInHandHistoryState copyWith({CashInHandHistoryListModel? model, int? pageSize, int? currentPage, bool? loadMore, CashInHandHistoryStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return CashInHandHistoryState(
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
