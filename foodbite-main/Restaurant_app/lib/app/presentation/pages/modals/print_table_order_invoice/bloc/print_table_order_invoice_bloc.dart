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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/bluetooth_paired_devices_model.dart';
import 'package:vendor/app/core/models/print_table_order_invoice_detail_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'print_table_order_invoice_event.dart';
part 'print_table_order_invoice_state.dart';

class PrintTableOrderInvoiceBloc extends Bloc<PrintTableOrderInvoiceEvent, PrintTableOrderInvoiceState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PrintTableOrderInvoiceBloc()
    : super(
        PrintTableOrderInvoiceState(
          model: PrintTableOrderInvoiceDetailModel(locale: ''),
          selectedDevice: BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none'),
        ),
      ) {
    on<PrintTableOrderInvoiceInitialEvent>(_onPrintTableOrderInvoiceInitialEvent);
    on<PrintTableOrderInvoiceContentWidthEvent>(_onPrintTableOrderInvoiceContentWidthEvent);
    on<PrintTableOrderInvoicePermissionFailedEvent>(_onPrintTableOrderInvoicePermissionFailedEvent);
    on<PrintTableOrderInvoiceDeviceFetchedEvent>(_onPrintTableOrderInvoiceDeviceFetchedEvent);
    on<PrintTableOrderInvoiceConnectDeviceEvent>(_onPrintTableOrderInvoiceConnectDeviceEvent);
    on<PrintTableOrderInvoiceChangeConnectionEvent>(_onPrintTableOrderInvoiceChangeConnectionEvent);
    on<PrintTableOrderInvoicePrintingProcessEvent>(_onPrintTableOrderInvoicePrintingProcessEvent);
  }

  FutureOr<void> _onPrintTableOrderInvoiceInitialEvent(PrintTableOrderInvoiceInitialEvent event, Emitter<PrintTableOrderInvoiceState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "print_table_order_invoice"}, 'print_table_order_invoice_screen', 'print_table_order_invoice_screen');
      emit(state.copyWith(status: PrintTableOrderInvoiceStatus.loading, orderId: event.orderId));
      DioApiResponse response = await _orderRepository.printTableOrderInvoice(event.orderId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PrintTableOrderInvoiceDetailModel data = PrintTableOrderInvoiceDetailModel.fromJson(myMap, locale.toString());
        List<BluetoothPairedDevicesModel> pairedDevices = <BluetoothPairedDevicesModel>[];
        BluetoothPairedDevicesModel defaultDevice = BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none');
        pairedDevices.add(defaultDevice);
        emit(state.copyWith(paired: pairedDevices, selectedDevice: defaultDevice, model: data, status: PrintTableOrderInvoiceStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PrintTableOrderInvoiceStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PrintTableOrderInvoiceStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPrintTableOrderInvoiceContentWidthEvent(PrintTableOrderInvoiceContentWidthEvent event, Emitter<PrintTableOrderInvoiceState> emit) async {
    emit(state.copyWith(contentWidth: event.width, status: PrintTableOrderInvoiceStatus.success));
  }

  FutureOr<void> _onPrintTableOrderInvoicePermissionFailedEvent(PrintTableOrderInvoicePermissionFailedEvent event, Emitter<PrintTableOrderInvoiceState> emit) async {
    emit(state.copyWith(alertMessage: '##d_y_n_a_m_i_c## Permission Denied', extraMessage: event.permission, statusCode: 0, status: PrintTableOrderInvoiceStatus.customError));
  }

  FutureOr<void> _onPrintTableOrderInvoiceDeviceFetchedEvent(PrintTableOrderInvoiceDeviceFetchedEvent event, Emitter<PrintTableOrderInvoiceState> emit) async {
    List<BluetoothPairedDevicesModel> pairedDevices = <BluetoothPairedDevicesModel>[];
    BluetoothPairedDevicesModel defaultDevice = BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none');
    pairedDevices.add(defaultDevice);
    for (var element in event.devices) {
      BluetoothPairedDevicesModel newDevice = BluetoothPairedDevicesModel(name: element.name, mac: element.macAdress);
      pairedDevices.add(newDevice);
    }
    PrintTableOrderInvoiceStatus status = state.status;
    emit(state.copyWith(paired: pairedDevices, selectedDevice: defaultDevice, status: status));
  }

  FutureOr<void> _onPrintTableOrderInvoiceConnectDeviceEvent(PrintTableOrderInvoiceConnectDeviceEvent event, Emitter<PrintTableOrderInvoiceState> emit) async {
    PrintTableOrderInvoiceStatus status = state.status;
    emit(state.copyWith(selectedDevice: event.device, status: status));
  }

  FutureOr<void> _onPrintTableOrderInvoiceChangeConnectionEvent(PrintTableOrderInvoiceChangeConnectionEvent event, Emitter<PrintTableOrderInvoiceState> emit) async {
    PrintTableOrderInvoiceStatus status = state.status;
    emit(state.copyWith(isConnected: event.isConnected, status: status));
  }

  FutureOr<void> _onPrintTableOrderInvoicePrintingProcessEvent(PrintTableOrderInvoicePrintingProcessEvent event, Emitter<PrintTableOrderInvoiceState> emit) async {
    PrintTableOrderInvoiceStatus status = state.status;
    emit(state.copyWith(isPrinting: event.isPrinting, status: status));
  }
}
