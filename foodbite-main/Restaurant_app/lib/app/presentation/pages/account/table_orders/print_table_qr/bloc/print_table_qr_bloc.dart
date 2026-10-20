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
import 'package:vendor/app/core/models/restaurant_table_qr_detail_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/table_order_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'print_table_qr_event.dart';
part 'print_table_qr_state.dart';

class PrintTableQrBloc extends Bloc<PrintTableQrEvent, PrintTableQrState> {
  final TableOrderRepository _tableOrderRepository = TableOrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  PrintTableQrBloc()
    : super(
        PrintTableQrState(
          model: RestaurantTableQRDetailModel(locale: ''),
          selectedDevice: BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none'),
        ),
      ) {
    on<PrintTableQrInitialEvent>(_onPrintTableQrInitialEvent);
    on<PrintTableQrContentWidthEvent>(_onPrintTableQrContentWidthEvent);
    on<PrintTableQrPermissionFailedEvent>(_onPrintTableQrPermissionFailedEvent);
    on<PrintTableQrDeviceFetchedEvent>(_onPrintTableQrDeviceFetchedEvent);
    on<PrintTableQrConnectDeviceEvent>(_onPrintTableQrConnectDeviceEvent);
    on<PrintTableQrChangeConnectionEvent>(_onPrintTableQrChangeConnectionEvent);
    on<PrintTableQrPrintingProcessEvent>(_onPrintTableQrPrintingProcessEvent);
  }

  FutureOr<void> _onPrintTableQrInitialEvent(PrintTableQrInitialEvent event, Emitter<PrintTableQrState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "print_table_qr"}, 'print_table_qr_screen', 'print_table_qr_screen');
      emit(state.copyWith(status: PrintTableQrStatus.loading));
      final String vendorId = await _tableOrderRepository.getVendorId();
      DioApiResponse response = await _tableOrderRepository.tableQrDetail();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        RestaurantTableQRDetailModel data = RestaurantTableQRDetailModel.fromJson(myMap, locale.toString());
        List<BluetoothPairedDevicesModel> pairedDevices = <BluetoothPairedDevicesModel>[];
        BluetoothPairedDevicesModel defaultDevice = BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none');
        pairedDevices.add(defaultDevice);
        final String qrPrintUrl = '${data.business!.websiteUrl!}table-order/$vendorId/${event.id}';
        emit(
          state.copyWith(
            id: event.id,
            capacity: event.capacity,
            tableNumber: event.tableNumber,
            tableStatus: event.status,
            paired: pairedDevices,
            selectedDevice: defaultDevice,
            model: data,
            qrPrintUrl: qrPrintUrl,
            status: PrintTableQrStatus.success,
          ),
        );
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: PrintTableQrStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: PrintTableQrStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onPrintTableQrContentWidthEvent(PrintTableQrContentWidthEvent event, Emitter<PrintTableQrState> emit) async {
    emit(state.copyWith(contentWidth: event.width, status: PrintTableQrStatus.success));
  }

  FutureOr<void> _onPrintTableQrPermissionFailedEvent(PrintTableQrPermissionFailedEvent event, Emitter<PrintTableQrState> emit) async {
    emit(state.copyWith(alertMessage: '##d_y_n_a_m_i_c## Permission Denied', extraMessage: event.permission, statusCode: 0, status: PrintTableQrStatus.customError));
  }

  FutureOr<void> _onPrintTableQrDeviceFetchedEvent(PrintTableQrDeviceFetchedEvent event, Emitter<PrintTableQrState> emit) async {
    List<BluetoothPairedDevicesModel> pairedDevices = <BluetoothPairedDevicesModel>[];
    BluetoothPairedDevicesModel defaultDevice = BluetoothPairedDevicesModel(name: 'dd_select', mac: 'none');
    pairedDevices.add(defaultDevice);
    for (var element in event.devices) {
      BluetoothPairedDevicesModel newDevice = BluetoothPairedDevicesModel(name: element.name, mac: element.macAdress);
      pairedDevices.add(newDevice);
    }
    PrintTableQrStatus status = state.status;
    emit(state.copyWith(paired: pairedDevices, selectedDevice: defaultDevice, status: status));
  }

  FutureOr<void> _onPrintTableQrConnectDeviceEvent(PrintTableQrConnectDeviceEvent event, Emitter<PrintTableQrState> emit) async {
    PrintTableQrStatus status = state.status;
    emit(state.copyWith(selectedDevice: event.device, status: status));
  }

  FutureOr<void> _onPrintTableQrChangeConnectionEvent(PrintTableQrChangeConnectionEvent event, Emitter<PrintTableQrState> emit) async {
    PrintTableQrStatus status = state.status;
    emit(state.copyWith(isConnected: event.isConnected, status: status));
  }

  FutureOr<void> _onPrintTableQrPrintingProcessEvent(PrintTableQrPrintingProcessEvent event, Emitter<PrintTableQrState> emit) async {
    PrintTableQrStatus status = state.status;
    emit(state.copyWith(isPrinting: event.isPrinting, status: status));
  }
}
