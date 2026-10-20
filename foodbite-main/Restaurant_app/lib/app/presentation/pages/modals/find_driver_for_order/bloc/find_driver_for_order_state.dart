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

part of 'find_driver_for_order_bloc.dart';

enum FindDriverForOrderStatus { loading, success, failure, empty, assign, assignSuccess, assignFailed }

extension FindDriverForOrderStatusX on FindDriverForOrderStatus {
  bool get isLoading => this == FindDriverForOrderStatus.loading;
  bool get isSuccess => this == FindDriverForOrderStatus.success;
  bool get isFailure => this == FindDriverForOrderStatus.failure;
  bool get isEmpty => this == FindDriverForOrderStatus.empty;
  bool get isAssign => this == FindDriverForOrderStatus.assign;
  bool get isAssignSuccess => this == FindDriverForOrderStatus.assignSuccess;
  bool get isAssignFailed => this == FindDriverForOrderStatus.assignFailed;
}

final class FindDriverForOrderState {
  final String orderId;
  final FetchDriverNearToOrderResponseModel model;
  final String selectedDriver;
  final FindDriverForOrderStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const FindDriverForOrderState({this.orderId = '', required this.model, this.selectedDriver = '', this.status = FindDriverForOrderStatus.loading, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  FindDriverForOrderState copyWith({String? orderId, FetchDriverNearToOrderResponseModel? model, String? selectedDriver, FindDriverForOrderStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return FindDriverForOrderState(
      orderId: orderId ?? this.orderId,
      model: model ?? this.model,
      selectedDriver: selectedDriver ?? this.selectedDriver,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
