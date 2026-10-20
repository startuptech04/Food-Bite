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

part of 'business_bloc.dart';

enum BusinessStatus { loading, success, failure }

extension BusinessStatusX on BusinessStatus {
  bool get isLoading => this == BusinessStatus.loading;
  bool get isSuccess => this == BusinessStatus.success;
  bool get isFailure => this == BusinessStatus.failure;
}

final class BusinessState {
  final BusinessStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const BusinessState({this.status = BusinessStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  BusinessState copyWith({BusinessStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return BusinessState(status: status ?? this.status, alertMessage: alertMessage ?? this.alertMessage, extraMessage: extraMessage ?? this.extraMessage, statusCode: statusCode ?? this.statusCode);
  }
}
