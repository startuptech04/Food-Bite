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

part of 'print_order_invoice_bloc.dart';

sealed class PrintOrderInvoiceEvent {}

final class PrintOrderInvoiceInitialEvent extends PrintOrderInvoiceEvent {
  final String orderId;
  PrintOrderInvoiceInitialEvent({required this.orderId});
}

final class PrintOrderInvoiceContentWidthEvent extends PrintOrderInvoiceEvent {
  final String width;
  PrintOrderInvoiceContentWidthEvent({required this.width});
}

final class PrintOrderInvoicePermissionFailedEvent extends PrintOrderInvoiceEvent {
  final String permission;
  PrintOrderInvoicePermissionFailedEvent({required this.permission});
}

final class PrintOrderInvoiceDeviceFetchedEvent extends PrintOrderInvoiceEvent {
  final List<BluetoothInfo> devices;
  PrintOrderInvoiceDeviceFetchedEvent({required this.devices});
}

final class PrintOrderInvoiceConnectDeviceEvent extends PrintOrderInvoiceEvent {
  final BluetoothPairedDevicesModel device;
  PrintOrderInvoiceConnectDeviceEvent({required this.device});
}

final class PrintOrderInvoiceChangeConnectionEvent extends PrintOrderInvoiceEvent {
  final bool isConnected;
  PrintOrderInvoiceChangeConnectionEvent({required this.isConnected});
}

final class PrintOrderInvoicePrintingProcessEvent extends PrintOrderInvoiceEvent {
  final bool isPrinting;
  PrintOrderInvoicePrintingProcessEvent({required this.isPrinting});
}
