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

part of 'deposite_bloc.dart';

enum DepositeStatus { loading, success, failure }

extension DepositeStatusX on DepositeStatus {
  bool get isLoading => this == DepositeStatus.loading;
  bool get isSuccess => this == DepositeStatus.success;
  bool get isFailure => this == DepositeStatus.failure;
}

final class DepositeState {
  final CashInHandModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMoreHistory;
  final bool loadMoreCollected;
  final String toggleTransaction;
  final DepositeStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DepositeState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMoreHistory = false,
    this.loadMoreCollected = false,
    this.toggleTransaction = 'in-hand',
    this.status = DepositeStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DepositeState copyWith({
    CashInHandModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMoreHistory,
    bool? loadMoreCollected,
    String? toggleTransaction,
    DepositeStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DepositeState(
      model: model ?? this.model,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMoreHistory: loadMoreHistory ?? this.loadMoreHistory,
      loadMoreCollected: loadMoreCollected ?? this.loadMoreCollected,
      toggleTransaction: toggleTransaction ?? this.toggleTransaction,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
