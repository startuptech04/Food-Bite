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
import 'package:vendor/app/core/models/food_taxation_checklist_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'food_taxation_checklist_modal_event.dart';
part 'food_taxation_checklist_modal_state.dart';

class FoodTaxationChecklistModalBloc extends Bloc<FoodTaxationChecklistModalEvent, FoodTaxationChecklistModalState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  FoodTaxationChecklistModalBloc() : super(const FoodTaxationChecklistModalState(savedTaxId: <String>[])) {
    on<FoodTaxationChecklistModalInitialEvent>(_onFoodTaxationChecklistModalInitialEvent);
    on<FoodTaxationChecklistModalSelectEvent>(_onFoodTaxationChecklistModalSelectEvent);
    on<FoodTaxationCheckListOnSaveEvent>(_onFoodTaxationCheckListOnSaveEvent);
  }

  FutureOr<void> _onFoodTaxationChecklistModalInitialEvent(FoodTaxationChecklistModalInitialEvent event, Emitter<FoodTaxationChecklistModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "food_taxation_checklist"}, 'food_taxation_checklist_screen', 'food_taxation_checklist_screen');
      emit(state.copyWith(status: FoodTaxationChecklistModalStatus.loading));
      final String vendorId = await _menuRepository.getVendorId();
      DioApiResponse response = await _menuRepository.getAllMyTaxation(vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        var taxation = (jsonDecode(response.body) as List).map((value) => FoodTaxationCheckListModel.fromJson(value, locale.toString())).toList();
        List<String> savedTaxIds = <String>[];
        if (event.savedTaxation.isNotEmpty) {
          savedTaxIds = event.savedTaxation.split(',');
        }
        emit(state.copyWith(status: taxation.isEmpty ? FoodTaxationChecklistModalStatus.empty : FoodTaxationChecklistModalStatus.success, taxations: taxation, savedTaxId: savedTaxIds));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: FoodTaxationChecklistModalStatus.failure, statusCode: 0, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: FoodTaxationChecklistModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onFoodTaxationChecklistModalSelectEvent(FoodTaxationChecklistModalSelectEvent event, Emitter<FoodTaxationChecklistModalState> emit) async {
    if (state.savedTaxId.contains(event.id)) {
      state.savedTaxId.removeWhere((element) => element == event.id);
      emit(state.copyWith(savedTaxId: [...state.savedTaxId]));
    } else {
      state.savedTaxId.add(event.id);
      emit(state.copyWith(savedTaxId: [...state.savedTaxId]));
    }
  }

  FutureOr<void> _onFoodTaxationCheckListOnSaveEvent(FoodTaxationCheckListOnSaveEvent event, Emitter<FoodTaxationChecklistModalState> emit) async {
    List<String> savedNames = <String>[];
    for (var element in state.taxations) {
      if (state.savedTaxId.contains(element.id!)) {
        savedNames.add(element.taxName!);
      }
    }
    state.savedTaxId.where((element) => element.isNotEmpty && element != '');
    savedNames.where((element) => element.isNotEmpty && element != '');
    emit(state.copyWith(savedTaxName: [...savedNames], savedTaxId: [...state.savedTaxId], status: FoodTaxationChecklistModalStatus.selected));
  }
}
