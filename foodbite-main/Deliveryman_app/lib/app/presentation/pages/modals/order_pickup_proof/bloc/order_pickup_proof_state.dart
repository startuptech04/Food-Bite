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

part of 'order_pickup_proof_bloc.dart';

enum OrderPickupProofStatus { initial, uploadLoaderStarted, uploadLoaderEnded, uploadLoaderEndedWithError }

extension OrderPickupProofStatusX on OrderPickupProofStatus {
  bool get isInitial => this == OrderPickupProofStatus.initial;
  bool get isUploadLoaderStarted => this == OrderPickupProofStatus.uploadLoaderStarted;
  bool get isUploadLoaderEnded => this == OrderPickupProofStatus.uploadLoaderEnded;
  bool get isUploadLoaderEndedWithError => this == OrderPickupProofStatus.uploadLoaderEndedWithError;
}

final class OrderPickupProofState {
  final String orderId;
  final String selectedMedia;
  final OrderPickupProofStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderPickupProofState({this.orderId = '', this.selectedMedia = '', this.status = OrderPickupProofStatus.initial, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OrderPickupProofState copyWith({String? orderId, String? selectedMedia, OrderPickupProofStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OrderPickupProofState(
      orderId: orderId ?? this.orderId,
      selectedMedia: selectedMedia ?? this.selectedMedia,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
