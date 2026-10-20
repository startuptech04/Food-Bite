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
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/active_driver_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/orders_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'select_driver_modal_event.dart';
part 'select_driver_modal_state.dart';

class SelectDriverModalBloc extends Bloc<SelectDriverModalEvent, SelectDriverModalState> {
  final OrderRepository _orderRepository = OrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  SelectDriverModalBloc() : super(SelectDriverModalState(driverList: ActiveDriverListModel(drivers: [], success: false))) {
    on<SelectDriverModalInitialEvent>(_onSelectDriverModalInitialEvent);
    on<SelectDriverModalSelectEvent>(_onSelectDriverModalSelectEvent);
  }

  FutureOr<void> _onSelectDriverModalInitialEvent(SelectDriverModalInitialEvent event, Emitter<SelectDriverModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "select_deliveryman"}, 'select_deliveryman_screen', 'select_deliveryman_screen');
      emit(state.copyWith(status: SelectDriverModalStatus.loading));
      final String vendorId = await _orderRepository.getVendorId();
      DioApiResponse response = await _orderRepository.activeDriver(vendorId);
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ActiveDriverListModel data = ActiveDriverListModel.fromJson(myMap);
        emit(state.copyWith(driverList: data, status: data.drivers!.isNotEmpty && data.success! ? SelectDriverModalStatus.success : SelectDriverModalStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SelectDriverModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SelectDriverModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSelectDriverModalSelectEvent(SelectDriverModalSelectEvent event, Emitter<SelectDriverModalState> emit) async {
    emit(state.copyWith(savedDriver: event.id, status: SelectDriverModalStatus.selected));
  }
}
