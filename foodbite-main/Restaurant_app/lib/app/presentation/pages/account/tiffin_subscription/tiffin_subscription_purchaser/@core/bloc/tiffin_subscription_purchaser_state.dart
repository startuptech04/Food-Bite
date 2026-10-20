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

part of 'tiffin_subscription_purchaser_bloc.dart';

enum TiffinSubscriptionPurchaserStatus { loading, success, failure, empty }

extension TiffinSubscriptionPurchaserStatusX on TiffinSubscriptionPurchaserStatus {
  bool get isLoading => this == TiffinSubscriptionPurchaserStatus.loading;
  bool get isSuccess => this == TiffinSubscriptionPurchaserStatus.success;
  bool get isFailure => this == TiffinSubscriptionPurchaserStatus.failure;
  bool get isEmpty => this == TiffinSubscriptionPurchaserStatus.empty;
}

final class TiffinSubscriptionPurchaserState {
  final String tiffinId;
  final TiffinSubscriptionPurchaserHistoryResponseModel model;
  final int pageSize;
  final int currentPage;
  final bool loadMore;
  final TiffinSubscriptionPurchaserStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const TiffinSubscriptionPurchaserState({
    this.tiffinId = '',
    required this.model,
    required this.pageSize,
    this.currentPage = 0,
    this.loadMore = false,
    this.status = TiffinSubscriptionPurchaserStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  TiffinSubscriptionPurchaserState copyWith({
    String? tiffinId,
    TiffinSubscriptionPurchaserHistoryResponseModel? model,
    int? pageSize,
    int? currentPage,
    bool? loadMore,
    TiffinSubscriptionPurchaserStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return TiffinSubscriptionPurchaserState(
      tiffinId: tiffinId ?? this.tiffinId,
      model: model ?? this.model,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      loadMore: loadMore ?? this.loadMore,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
