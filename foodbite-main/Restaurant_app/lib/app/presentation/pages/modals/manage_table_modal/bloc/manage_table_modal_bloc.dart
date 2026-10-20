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
import 'package:formz/formz.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/models/request/create_or_update_restaurant_table_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/table_order_repository.dart';
import 'package:vendor/app/core/validations/restaurant_table_form.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'manage_table_modal_event.dart';
part 'manage_table_modal_state.dart';

class ManageTableModalBloc extends Bloc<ManageTableModalEvent, ManageTableModalState> {
  final TableOrderRepository _tableOrderRepository = TableOrderRepository();
  final AccountRepository _accountRepository = AccountRepository();
  ManageTableModalBloc() : super(const ManageTableModalState()) {
    on<ManageTableModalInitialEvent>(_onManageTableModalInitialEvent);
    on<ManageTableModalNumberChangedEvent>(_onManageTableModalNumberChangedEvent);
    on<ManageTableModalNumberUnfocusedEvent>(_onManageTableModalNumberUnfocusedEvent);
    on<ManageTableModalCapacityChangedEvent>(_onManageTableModalCapacityChangedEvent);
    on<ManageTableModalCapacityUnfocusedEvent>(_onManageTableModalCapacityUnfocusedEvent);
    on<ManageTableModalSubmitEvent>(_onManageTableModalSubmitEvent);
  }

  FutureOr<void> _onManageTableModalInitialEvent(ManageTableModalInitialEvent event, Emitter<ManageTableModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_update_dining_table_detail"}, 'add_update_dining_table_detail_screen', 'add_update_dining_table_detail_screen');
    if (!event.isNew) {
      final tableNumber = RestaurantTableNumberField.dirty(event.tableNumber.toString());
      final tableCapacity = RestaurantTableCapacityField.dirty(event.capacity.toString());
      emit(state.copyWith(status: ManageTableModalStatus.initial, numberField: tableNumber, capacityField: tableCapacity, tableId: event.tableId, isNew: false, isValid: Formz.validate([tableNumber, tableCapacity])));
    } else {
      emit(state.copyWith(status: ManageTableModalStatus.initial, isNew: true));
    }
  }

  FutureOr<void> _onManageTableModalNumberChangedEvent(ManageTableModalNumberChangedEvent event, Emitter<ManageTableModalState> emit) async {
    final tableNumber = RestaurantTableNumberField.dirty(event.number);
    emit(state.copyWith(numberField: tableNumber.isValid ? tableNumber : RestaurantTableNumberField.pure(event.number), isValid: Formz.validate([tableNumber, state.capacityField]), status: ManageTableModalStatus.initial));
  }

  FutureOr<void> _onManageTableModalNumberUnfocusedEvent(ManageTableModalNumberUnfocusedEvent event, Emitter<ManageTableModalState> emit) async {
    final tableNumber = RestaurantTableNumberField.dirty(state.numberField.value);
    emit(state.copyWith(numberField: tableNumber, isValid: Formz.validate([tableNumber, state.capacityField]), status: ManageTableModalStatus.initial));
  }

  FutureOr<void> _onManageTableModalCapacityChangedEvent(ManageTableModalCapacityChangedEvent event, Emitter<ManageTableModalState> emit) async {
    final tableCapacity = RestaurantTableCapacityField.dirty(event.capacity);
    emit(
      state.copyWith(capacityField: tableCapacity.isValid ? tableCapacity : RestaurantTableCapacityField.pure(event.capacity), isValid: Formz.validate([tableCapacity, state.numberField]), status: ManageTableModalStatus.initial),
    );
  }

  FutureOr<void> _onManageTableModalCapacityUnfocusedEvent(ManageTableModalCapacityUnfocusedEvent event, Emitter<ManageTableModalState> emit) async {
    final tableCapacity = RestaurantTableCapacityField.dirty(state.capacityField.value);
    emit(state.copyWith(capacityField: tableCapacity, isValid: Formz.validate([tableCapacity, state.numberField]), status: ManageTableModalStatus.initial));
  }

  FutureOr<void> _onManageTableModalSubmitEvent(ManageTableModalSubmitEvent event, Emitter<ManageTableModalState> emit) async {
    try {
      final tableNumber = RestaurantTableNumberField.dirty(state.numberField.value);
      final tableCapacity = RestaurantTableCapacityField.dirty(state.capacityField.value);
      emit(state.copyWith(numberField: tableNumber, capacityField: tableCapacity, isValid: Formz.validate([tableNumber, tableCapacity]), status: ManageTableModalStatus.initial));
      if (state.isValid && state.numberField.value.toString().isNotEmpty && state.capacityField.value.toString().isNotEmpty) {
        if (state.isNew) {
          final String vendorId = await _tableOrderRepository.getVendorId();
          CreateOrUpdateRestaurantTableRequestModel param = CreateOrUpdateRestaurantTableRequestModel(restaurant: vendorId, tableNumber: tableNumber.value.toString(), capacity: tableCapacity.value.toString());
          DioApiResponse response = await _tableOrderRepository.createRestaurantTable(param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageTableModalStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageTableModalStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        } else {
          emit(state.copyWith(status: ManageTableModalStatus.submit));
          final String vendorId = await _tableOrderRepository.getVendorId();
          CreateOrUpdateRestaurantTableRequestModel param = CreateOrUpdateRestaurantTableRequestModel(restaurant: vendorId, tableNumber: tableNumber.value.toString(), capacity: tableCapacity.value.toString());
          DioApiResponse response = await _tableOrderRepository.updateRestaurantTable(state.tableId, param);
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(status: ManageTableModalStatus.submitSuccess));
          } else {
            Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
            ServerErrorModel data = ServerErrorModel.fromJson(myMap);
            emit(state.copyWith(status: ManageTableModalStatus.submitFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
          }
        }
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: ManageTableModalStatus.submitFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
