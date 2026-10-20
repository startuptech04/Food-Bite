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
import 'package:vendor/app/core/models/print_invoice_detail_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'print_order_invoice_event.dart';
part 'print_order_invoice_state.dart';

class PrintOrderInvoiceBloc extends Bloc<PrintOrderInvoiceEvent, PrintOrderInvoiceState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PrintOrderInvoiceBloc()
    : super(
        PrintOrderInvoiceState(
          model: PrintInvoiceDetailModel(locale: ''),
          selectedDevice: BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none'),
        ),
      ) {
    on<PrintOrderInvoiceInitialEvent>(_onPrintOrderInvoiceInitialEvent);
    on<PrintOrderInvoiceContentWidthEvent>(_onPrintOrderInvoiceContentWidthEvent);
    on<PrintOrderInvoicePermissionFailedEvent>(_onPrintOrderInvoicePermissionFailedEvent);
    on<PrintOrderInvoiceDeviceFetchedEvent>(_onPrintOrderInvoiceDeviceFetchedEvent);
    on<PrintOrderInvoiceConnectDeviceEvent>(_onPrintOrderInvoiceConnectDeviceEvent);
    on<PrintOrderInvoiceChangeConnectionEvent>(_onPrintOrderInvoiceChangeConnectionEvent);
    on<PrintOrderInvoicePrintingProcessEvent>(_onPrintOrderInvoicePrintingProcessEvent);
  }

  FutureOr<void> _onPrintOrderInvoiceInitialEvent(PrintOrderInvoiceInitialEvent event, Emitter<PrintOrderInvoiceState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "print_order_invoice"}, 'print_order_invoice_screen', 'print_order_invoice_screen');
      emit(state.copyWith(status: PrintOrderInvoiceStatus.loading, orderId: event.orderId));
      DioApiResponse response = await _orderRepository.printInvoice(event.orderId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        PrintInvoiceDetailModel data = PrintInvoiceDetailModel.fromJson(myMap, locale.toString());
        List<BluetoothPairedDevicesModel> pairedDevices = <BluetoothPairedDevicesModel>[];
        BluetoothPairedDevicesModel defaultDevice = BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none');
        pairedDevices.add(defaultDevice);
        emit(state.copyWith(paired: pairedDevices, selectedDevice: defaultDevice, model: data, status: PrintOrderInvoiceStatus.success));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PrintOrderInvoiceStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PrintOrderInvoiceStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPrintOrderInvoiceContentWidthEvent(PrintOrderInvoiceContentWidthEvent event, Emitter<PrintOrderInvoiceState> emit) async {
    emit(state.copyWith(contentWidth: event.width, status: PrintOrderInvoiceStatus.success));
  }

  FutureOr<void> _onPrintOrderInvoicePermissionFailedEvent(PrintOrderInvoicePermissionFailedEvent event, Emitter<PrintOrderInvoiceState> emit) async {
    emit(state.copyWith(alertMessage: '##d_y_n_a_m_i_c## Permission Denied', extraMessage: event.permission, statusCode: 0, status: PrintOrderInvoiceStatus.customError));
  }

  FutureOr<void> _onPrintOrderInvoiceDeviceFetchedEvent(PrintOrderInvoiceDeviceFetchedEvent event, Emitter<PrintOrderInvoiceState> emit) async {
    List<BluetoothPairedDevicesModel> pairedDevices = <BluetoothPairedDevicesModel>[];
    BluetoothPairedDevicesModel defaultDevice = BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none');
    pairedDevices.add(defaultDevice);
    for (var element in event.devices) {
      BluetoothPairedDevicesModel newDevice = BluetoothPairedDevicesModel(name: element.name, mac: element.macAdress);
      pairedDevices.add(newDevice);
    }
    PrintOrderInvoiceStatus status = state.status;
    emit(state.copyWith(paired: pairedDevices, selectedDevice: defaultDevice, status: status));
  }

  FutureOr<void> _onPrintOrderInvoiceConnectDeviceEvent(PrintOrderInvoiceConnectDeviceEvent event, Emitter<PrintOrderInvoiceState> emit) async {
    PrintOrderInvoiceStatus status = state.status;
    emit(state.copyWith(selectedDevice: event.device, status: status));
  }

  FutureOr<void> _onPrintOrderInvoiceChangeConnectionEvent(PrintOrderInvoiceChangeConnectionEvent event, Emitter<PrintOrderInvoiceState> emit) async {
    PrintOrderInvoiceStatus status = state.status;
    emit(state.copyWith(isConnected: event.isConnected, status: status));
  }

  FutureOr<void> _onPrintOrderInvoicePrintingProcessEvent(PrintOrderInvoicePrintingProcessEvent event, Emitter<PrintOrderInvoiceState> emit) async {
    PrintOrderInvoiceStatus status = state.status;
    emit(state.copyWith(isPrinting: event.isPrinting, status: status));
  }
}
