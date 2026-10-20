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

part of 'dining_booking_transaction_bloc.dart';

enum DiningBookingTransactionStatus { loading, success, failure, empty, unAuthorized }

extension DiningBookingTransactionStatusX on DiningBookingTransactionStatus {
  bool get isLoading => this == DiningBookingTransactionStatus.loading;
  bool get isSuccess => this == DiningBookingTransactionStatus.success;
  bool get isFailure => this == DiningBookingTransactionStatus.failure;
  bool get isEmpty => this == DiningBookingTransactionStatus.empty;
  bool get isUnAuthorized => this == DiningBookingTransactionStatus.unAuthorized;
}

final class DiningBookingTransactionState {
  final UserDiningTransactionResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final DiningBookingTransactionStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const DiningBookingTransactionState({
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = DiningBookingTransactionStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  DiningBookingTransactionState copyWith({
    UserDiningTransactionResponseModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    DiningBookingTransactionStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return DiningBookingTransactionState(
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
