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
import 'package:vendor/app/core/models/addons_list_model.dart';
import 'package:vendor/app/core/models/request/addon_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'addons_event.dart';
part 'addons_state.dart';

class AddonsBloc extends Bloc<AddonsEvent, AddonsState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  AddonsBloc()
    : super(
        AddonsState(
          addons: AddonListModel(locale: ''),
          pageSize: ApiRequestService.pageSize,
        ),
      ) {
    on<AddonsInitialEvent>(_onAddonsInitialEvent);
    on<AddonsLoadMoreEvent>(_onAddonsLoadMoreEvent);
    on<AddonsDeleteEvent>(_onAddonsDeleteEvent);
    on<AddonsChangeStatusEvent>(_onAddonsChangeStatusEvent);
    on<AddonsChangeStockEvent>(_onAddonsChangeStockEvent);
  }

  FutureOr<void> _onAddonsInitialEvent(AddonsInitialEvent event, Emitter<AddonsState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "food_addons"}, 'food_addons_screen', 'food_addons_screen');
      emit(state.copyWith(status: AddonStatus.loading));
      final String vendorId = await _menuRepository.getVendorId();
      DioApiResponse response = await _menuRepository.getAddons(state.pageSize, state.currentPage, vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        AddonListModel data = AddonListModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: AddonStatus.success, appLocale: locale.toString(), addons: data));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AddonStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AddonStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onAddonsLoadMoreEvent(AddonsLoadMoreEvent event, Emitter<AddonsState> emit) async {
    if (state.addons.results!.length < state.addons.totalResults!) {
      emit(state.copyWith(loadMore: true));
      try {
        final String vendorId = await _menuRepository.getVendorId();
        DioApiResponse response = await _menuRepository.getAddons(state.pageSize * 2, state.currentPage, vendorId);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          AddonListModel data = AddonListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(status: AddonStatus.success, addons: data, loadMore: false, pageSize: state.pageSize * 2));
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: AddonStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), loadMore: false, extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: AddonStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  FutureOr<void> _onAddonsDeleteEvent(AddonsDeleteEvent event, Emitter<AddonsState> emit) async {
    emit(state.copyWith(status: AddonStatus.deleteLoaderStarted));
    try {
      DioApiResponse response = await _menuRepository.deleteAddon(event.id);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: AddonStatus.deleteLoaderEnded));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AddonStatus.deleteLoaderEndedWithError, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AddonStatus.deleteLoaderEndedWithError, statusCode: 0, alertMessage: e.toString(), extraMessage: '', loadMore: false));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onAddonsChangeStatusEvent(AddonsChangeStatusEvent event, Emitter<AddonsState> emit) async {
    state.addons.results!.firstWhere((element) => element.id == event.id).status = event.status;
    emit(state.copyWith(addons: state.addons));
    try {
      AddonsRequestModel param = AddonsRequestModel(
        status: event.status,
        name: event.model.name!,
        price: event.model.price.toString(),
        restaurant: event.model.restaurant!,
        stockNumber: event.model.stockNumber!,
        stockType: event.model.stockType!,
        inStock: event.model.inStock!,
      );
      DioApiResponse response = await _menuRepository.updateAddon(event.id, param);
      if (response.errorType != NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AddonStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AddonStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onAddonsChangeStockEvent(AddonsChangeStockEvent event, Emitter<AddonsState> emit) async {
    state.addons.results!.firstWhere((element) => element.id == event.id).inStock = event.inStock;
    emit(state.copyWith(addons: state.addons));
    try {
      AddonsRequestModel param = AddonsRequestModel(
        status: event.model.status,
        name: event.model.name!,
        price: event.model.price.toString(),
        restaurant: event.model.restaurant!,
        stockNumber: event.model.stockNumber!,
        stockType: event.model.stockType!,
        inStock: event.inStock,
      );
      DioApiResponse response = await _menuRepository.updateAddon(event.id, param);
      if (response.errorType != NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AddonStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AddonStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
