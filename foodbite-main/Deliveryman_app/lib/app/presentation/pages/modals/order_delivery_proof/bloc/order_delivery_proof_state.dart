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

part of 'order_delivery_proof_bloc.dart';

enum OrderDeliveryProofStatus { initial, uploadLoaderStarted, uploadLoaderEnded, uploadLoaderEndedWithError }

extension OrderDeliveryProofStatusX on OrderDeliveryProofStatus {
  bool get isInitial => this == OrderDeliveryProofStatus.initial;
  bool get isUploadLoaderStarted => this == OrderDeliveryProofStatus.uploadLoaderStarted;
  bool get isUploadLoaderEnded => this == OrderDeliveryProofStatus.uploadLoaderEnded;
  bool get isUploadLoaderEndedWithError => this == OrderDeliveryProofStatus.uploadLoaderEndedWithError;
}

final class OrderDeliveryProofState {
  final String orderId;
  final String selectedMedia;
  final OrderDeliveryProofStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const OrderDeliveryProofState({this.orderId = '', this.selectedMedia = '', this.status = OrderDeliveryProofStatus.initial, this.alertMessage = '', this.extraMessage = '', this.statusCode = 0});

  OrderDeliveryProofState copyWith({String? orderId, String? selectedMedia, OrderDeliveryProofStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return OrderDeliveryProofState(
      orderId: orderId ?? this.orderId,
      selectedMedia: selectedMedia ?? this.selectedMedia,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
