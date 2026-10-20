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

sealed class PrintPosOrderInvoiceEvent {}

final class PrintPosOrderInvoiceInitialEvent extends PrintPosOrderInvoiceEvent {
  final String orderId;
  PrintPosOrderInvoiceInitialEvent({required this.orderId});
}

final class PrintPosOrderInvoiceContentWidthEvent extends PrintPosOrderInvoiceEvent {
  final String width;
  PrintPosOrderInvoiceContentWidthEvent({required this.width});
}

final class PrintPosOrderInvoicePermissionFailedEvent extends PrintPosOrderInvoiceEvent {
  final String permission;
  PrintPosOrderInvoicePermissionFailedEvent({required this.permission});
}

final class PrintPosOrderInvoiceDeviceFetchedEvent extends PrintPosOrderInvoiceEvent {
  final List<BluetoothInfo> devices;
  PrintPosOrderInvoiceDeviceFetchedEvent({required this.devices});
}

final class PrintPosOrderInvoiceConnectDeviceEvent extends PrintPosOrderInvoiceEvent {
  final BluetoothPairedDevicesModel device;
  PrintPosOrderInvoiceConnectDeviceEvent({required this.device});
}

final class PrintPosOrderInvoiceChangeConnectionEvent extends PrintPosOrderInvoiceEvent {
  final bool isConnected;
  PrintPosOrderInvoiceChangeConnectionEvent({required this.isConnected});
}

final class PrintPosOrderInvoicePrintingProcessEvent extends PrintPosOrderInvoiceEvent {
  final bool isPrinting;
  PrintPosOrderInvoicePrintingProcessEvent({required this.isPrinting});
}
