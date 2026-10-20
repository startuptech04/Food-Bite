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

sealed class PrintTableOrderInvoiceEvent {}

final class PrintTableOrderInvoiceInitialEvent extends PrintTableOrderInvoiceEvent {
  final String orderId;
  PrintTableOrderInvoiceInitialEvent({required this.orderId});
}

final class PrintTableOrderInvoiceContentWidthEvent extends PrintTableOrderInvoiceEvent {
  final String width;
  PrintTableOrderInvoiceContentWidthEvent({required this.width});
}

final class PrintTableOrderInvoicePermissionFailedEvent extends PrintTableOrderInvoiceEvent {
  final String permission;
  PrintTableOrderInvoicePermissionFailedEvent({required this.permission});
}

final class PrintTableOrderInvoiceDeviceFetchedEvent extends PrintTableOrderInvoiceEvent {
  final List<BluetoothInfo> devices;
  PrintTableOrderInvoiceDeviceFetchedEvent({required this.devices});
}

final class PrintTableOrderInvoiceConnectDeviceEvent extends PrintTableOrderInvoiceEvent {
  final BluetoothPairedDevicesModel device;
  PrintTableOrderInvoiceConnectDeviceEvent({required this.device});
}

final class PrintTableOrderInvoiceChangeConnectionEvent extends PrintTableOrderInvoiceEvent {
  final bool isConnected;
  PrintTableOrderInvoiceChangeConnectionEvent({required this.isConnected});
}

final class PrintTableOrderInvoicePrintingProcessEvent extends PrintTableOrderInvoiceEvent {
  final bool isPrinting;
  PrintTableOrderInvoicePrintingProcessEvent({required this.isPrinting});
}
