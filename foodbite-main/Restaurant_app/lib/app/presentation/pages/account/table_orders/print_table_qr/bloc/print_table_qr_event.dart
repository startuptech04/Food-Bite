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

sealed class PrintTableQrEvent {}

final class PrintTableQrInitialEvent extends PrintTableQrEvent {
  final int capacity;
  final String id;
  final bool status;
  final int tableNumber;
  PrintTableQrInitialEvent({required this.capacity, required this.id, required this.status, required this.tableNumber});
}

final class PrintTableQrContentWidthEvent extends PrintTableQrEvent {
  final String width;
  PrintTableQrContentWidthEvent({required this.width});
}

final class PrintTableQrPermissionFailedEvent extends PrintTableQrEvent {
  final String permission;
  PrintTableQrPermissionFailedEvent({required this.permission});
}

final class PrintTableQrDeviceFetchedEvent extends PrintTableQrEvent {
  final List<BluetoothInfo> devices;
  PrintTableQrDeviceFetchedEvent({required this.devices});
}

final class PrintTableQrConnectDeviceEvent extends PrintTableQrEvent {
  final BluetoothPairedDevicesModel device;
  PrintTableQrConnectDeviceEvent({required this.device});
}

final class PrintTableQrChangeConnectionEvent extends PrintTableQrEvent {
  final bool isConnected;
  PrintTableQrChangeConnectionEvent({required this.isConnected});
}

final class PrintTableQrPrintingProcessEvent extends PrintTableQrEvent {
  final bool isPrinting;
  PrintTableQrPrintingProcessEvent({required this.isPrinting});
}
