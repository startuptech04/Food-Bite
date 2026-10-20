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

part of 'print_pos_order_invoice_bloc.dart';

enum PrintPosOrderInvoiceStatus { loading, success, failure, customError }

extension PrintPosOrderInvoiceStatusX on PrintPosOrderInvoiceStatus {
  bool get isLoading => this == PrintPosOrderInvoiceStatus.loading;
  bool get isSuccess => this == PrintPosOrderInvoiceStatus.success;
  bool get isFailure => this == PrintPosOrderInvoiceStatus.failure;
  bool get isCustomError => this == PrintPosOrderInvoiceStatus.customError;
}

final class PrintPosOrderInvoiceState {
  final String orderId;
  final String contentWidth;
  final List<BluetoothPairedDevicesModel> paired;
  final BluetoothPairedDevicesModel selectedDevice;
  final bool isConnected;
  final bool isPrinting;
  final PrintPOSInvoiceDetailModel model;
  final PrintPosOrderInvoiceStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const PrintPosOrderInvoiceState({
    this.orderId = '',
    this.contentWidth = '58mm',
    this.paired = const [],
    required this.selectedDevice,
    this.isConnected = false,
    this.isPrinting = false,
    required this.model,
    this.status = PrintPosOrderInvoiceStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  PrintPosOrderInvoiceState copyWith({
    String? orderId,
    String? contentWidth,
    List<BluetoothPairedDevicesModel>? paired,
    BluetoothPairedDevicesModel? selectedDevice,
    bool? isConnected,
    bool? isPrinting,
    PrintPOSInvoiceDetailModel? model,
    PrintPosOrderInvoiceStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return PrintPosOrderInvoiceState(
      orderId: orderId ?? this.orderId,
      contentWidth: contentWidth ?? this.contentWidth,
      paired: paired ?? this.paired,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isConnected: isConnected ?? this.isConnected,
      isPrinting: isPrinting ?? this.isPrinting,
      model: model ?? this.model,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
