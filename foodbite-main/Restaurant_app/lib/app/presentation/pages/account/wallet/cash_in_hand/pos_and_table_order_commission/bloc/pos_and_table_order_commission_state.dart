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

part of 'pos_and_table_order_commission_bloc.dart';

enum PosAndTableOrderCommissionStatus { loading, success, failure, empty, customError }

extension PosAndTableOrderCommissionStatusX on PosAndTableOrderCommissionStatus {
  bool get isLoading => this == PosAndTableOrderCommissionStatus.loading;
  bool get isSuccess => this == PosAndTableOrderCommissionStatus.success;
  bool get isFailure => this == PosAndTableOrderCommissionStatus.failure;
  bool get isEmpty => this == PosAndTableOrderCommissionStatus.empty;
  bool get isCustomError => this == PosAndTableOrderCommissionStatus.customError;
}

final class PosAndTableOrderCommissionState {
  final PosAndTableOrderCommissionHistoryListModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final PosAndTableOrderCommissionStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const PosAndTableOrderCommissionState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = PosAndTableOrderCommissionStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  PosAndTableOrderCommissionState copyWith({
    PosAndTableOrderCommissionHistoryListModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    PosAndTableOrderCommissionStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return PosAndTableOrderCommissionState(
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
