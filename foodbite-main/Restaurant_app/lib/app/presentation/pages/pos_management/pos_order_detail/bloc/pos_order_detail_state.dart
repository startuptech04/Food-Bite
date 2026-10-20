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

part of 'pos_order_detail_bloc.dart';

enum PosOrderDetailStatus { loading, success, failure, customError }

extension PosOrderDetailStatusX on PosOrderDetailStatus {
  bool get isLoading => this == PosOrderDetailStatus.loading;
  bool get isSuccess => this == PosOrderDetailStatus.success;
  bool get isFailure => this == PosOrderDetailStatus.failure;
  bool get isCustomError => this == PosOrderDetailStatus.customError;
}

final class PosOrderDetailState {
  final String orderId;
  final PosOrderDetailModel model;
  final PosOrderDetailStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const PosOrderDetailState({this.orderId = '', required this.model, this.status = PosOrderDetailStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  PosOrderDetailState copyWith({String? orderId, PosOrderDetailModel? model, PosOrderDetailStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return PosOrderDetailState(
      orderId: orderId ?? this.orderId,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
