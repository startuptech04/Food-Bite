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

part of 'print_table_order_invoice_bloc.dart';

enum PrintTableOrderInvoiceStatus { loading, success, failure, customError }

extension PrintTableOrderInvoiceStatusX on PrintTableOrderInvoiceStatus {
  bool get isLoading => this == PrintTableOrderInvoiceStatus.loading;
  bool get isSuccess => this == PrintTableOrderInvoiceStatus.success;
  bool get isFailure => this == PrintTableOrderInvoiceStatus.failure;
  bool get isCustomError => this == PrintTableOrderInvoiceStatus.customError;
}

final class PrintTableOrderInvoiceState {
  final String orderId;
  final String contentWidth;
  final List<BluetoothPairedDevicesModel> paired;
  final BluetoothPairedDevicesModel selectedDevice;
  final bool isConnected;
  final bool isPrinting;
  final PrintTableOrderInvoiceDetailModel model;
  final PrintTableOrderInvoiceStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const PrintTableOrderInvoiceState({
    this.orderId = '',
    this.contentWidth = '58mm',
    this.paired = const [],
    required this.selectedDevice,
    this.isConnected = false,
    this.isPrinting = false,
    required this.model,
    this.status = PrintTableOrderInvoiceStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  PrintTableOrderInvoiceState copyWith({
    String? orderId,
    String? contentWidth,
    List<BluetoothPairedDevicesModel>? paired,
    BluetoothPairedDevicesModel? selectedDevice,
    bool? isConnected,
    bool? isPrinting,
    PrintTableOrderInvoiceDetailModel? model,
    PrintTableOrderInvoiceStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return PrintTableOrderInvoiceState(
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
