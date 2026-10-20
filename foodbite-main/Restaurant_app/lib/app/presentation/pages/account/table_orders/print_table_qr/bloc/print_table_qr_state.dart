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

part of 'print_table_qr_bloc.dart';

enum PrintTableQrStatus { loading, success, failure, customError }

extension PrintTableQrStatusX on PrintTableQrStatus {
  bool get isLoading => this == PrintTableQrStatus.loading;
  bool get isSuccess => this == PrintTableQrStatus.success;
  bool get isFailure => this == PrintTableQrStatus.failure;
  bool get isCustomError => this == PrintTableQrStatus.customError;
}

final class PrintTableQrState {
  final int capacity;
  final String id;
  final bool tableStatus;
  final int tableNumber;
  final RestaurantTableQRDetailModel model;
  final String contentWidth;
  final List<BluetoothPairedDevicesModel> paired;
  final BluetoothPairedDevicesModel selectedDevice;
  final bool isConnected;
  final bool isPrinting;
  final String qrPrintUrl;
  final PrintTableQrStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const PrintTableQrState({
    this.capacity = 0,
    this.id = '',
    this.tableStatus = false,
    this.tableNumber = 0,
    required this.model,
    this.contentWidth = '88mm',
    this.paired = const [],
    required this.selectedDevice,
    this.isConnected = false,
    this.isPrinting = false,
    this.qrPrintUrl = '',
    this.status = PrintTableQrStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  PrintTableQrState copyWith({
    int? capacity,
    String? id,
    bool? tableStatus,
    int? tableNumber,
    RestaurantTableQRDetailModel? model,
    String? contentWidth,
    List<BluetoothPairedDevicesModel>? paired,
    BluetoothPairedDevicesModel? selectedDevice,
    bool? isConnected,
    bool? isPrinting,
    String? qrPrintUrl,
    PrintTableQrStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return PrintTableQrState(
      capacity: capacity ?? this.capacity,
      id: id ?? this.id,
      tableStatus: tableStatus ?? this.tableStatus,
      tableNumber: tableNumber ?? this.tableNumber,
      model: model ?? this.model,
      contentWidth: contentWidth ?? this.contentWidth,
      paired: paired ?? this.paired,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isConnected: isConnected ?? this.isConnected,
      isPrinting: isPrinting ?? this.isPrinting,
      qrPrintUrl: qrPrintUrl ?? this.qrPrintUrl,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
