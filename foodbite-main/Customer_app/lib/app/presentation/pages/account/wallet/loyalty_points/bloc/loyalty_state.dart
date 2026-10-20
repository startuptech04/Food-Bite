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

part of 'loyalty_bloc.dart';

enum LoyaltyStatus { loading, success, failure, empty, redeeming, redeemSuccess, customError, unAuthorized }

extension LoyaltyStatusX on LoyaltyStatus {
  bool get isLoading => this == LoyaltyStatus.loading;
  bool get isSuccess => this == LoyaltyStatus.success;
  bool get isFailure => this == LoyaltyStatus.failure;
  bool get isEmpty => this == LoyaltyStatus.empty;
  bool get isRedeeming => this == LoyaltyStatus.redeeming;
  bool get isRedeemSuccess => this == LoyaltyStatus.redeemSuccess;
  bool get isCustomError => this == LoyaltyStatus.customError;
  bool get isUnAuthorized => this == LoyaltyStatus.unAuthorized;
}

final class LoyaltyState {
  final LoyaltyPointsResponseModel points;
  final LoyaltyStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const LoyaltyState({required this.points, this.status = LoyaltyStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  LoyaltyState copyWith({LoyaltyPointsResponseModel? points, LoyaltyStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return LoyaltyState(points: points ?? this.points, status: status ?? this.status, statusCode: statusCode ?? this.statusCode, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage);
  }
}
