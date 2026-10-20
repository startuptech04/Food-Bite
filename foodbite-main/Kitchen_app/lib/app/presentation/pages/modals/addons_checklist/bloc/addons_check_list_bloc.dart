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
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/models/addonst_checklist_model.dart';
import 'package:kitchen/app/core/models/server_error_model.dart';
import 'package:kitchen/app/core/repositories/auth_repository.dart';
import 'package:kitchen/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'addons_check_list_event.dart';
part 'addons_check_list_state.dart';

class AddonsCheckListBloc extends Bloc<AddonsCheckListEvent, AddonsCheckListState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AuthRepository _authRepository = AuthRepository();
  AddonsCheckListBloc() : super(const AddonsCheckListState(savedAddonsId: <String>[])) {
    on<AddonsCheckListInitialEvent>(_onAddonsCheckListInitialEvent);
    on<AddonsCheckListOnTapEvent>(_onAddonsCheckListOnTapEvent);
    on<AddonsCheckListOnSaveEvent>(_onAddonsCheckListOnSaveEvent);
  }

  FutureOr<void> _onAddonsCheckListInitialEvent(AddonsCheckListInitialEvent event, Emitter<AddonsCheckListState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "addon_checklist"}, 'addon_checklist_screen', 'addon_checklist_screen');
      emit(state.copyWith(status: AddonsCheckListStatus.loading));
      DioApiResponse response = await _menuRepository.getAllMyAddonsList();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _authRepository.getLocale();
        var addons = (jsonDecode(response.body) as List).map((value) => AddonsCheckListModel.fromJson(value, locale.toString())).toList();
        event.savedAddons.where((element) => element.isNotEmpty && element != '');
        emit(state.copyWith(status: addons.isEmpty ? AddonsCheckListStatus.empty : AddonsCheckListStatus.success, addons: addons, savedAddonsId: event.savedAddons));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: AddonsCheckListStatus.failure, statusCode: 0, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: AddonsCheckListStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onAddonsCheckListOnTapEvent(AddonsCheckListOnTapEvent event, Emitter<AddonsCheckListState> emit) async {
    if (state.savedAddonsId.contains(event.id)) {
      state.savedAddonsId.removeWhere((element) => element == event.id);
      emit(state.copyWith(savedAddonsId: [...state.savedAddonsId]));
    } else {
      state.savedAddonsId.add(event.id);
      emit(state.copyWith(savedAddonsId: [...state.savedAddonsId]));
    }
  }

  FutureOr<void> _onAddonsCheckListOnSaveEvent(AddonsCheckListOnSaveEvent event, Emitter<AddonsCheckListState> emit) async {
    List<String> savedNames = <String>[];
    for (var element in state.addons) {
      if (state.savedAddonsId.contains(element.id!)) {
        savedNames.add(element.name!);
      }
    }
    state.savedAddonsId.where((element) => element.isNotEmpty && element != '');
    savedNames.where((element) => element.isNotEmpty && element != '');
    emit(state.copyWith(savedAddonsName: [...savedNames], savedAddonsId: [...state.savedAddonsId], status: AddonsCheckListStatus.selected));
  }
}
