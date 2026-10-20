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
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/models/active_cuisine_list_model.dart';
import 'package:user/app/core/models/api_status_response_model.dart';
import 'package:user/app/core/models/server_error_model.dart';
import 'package:user/app/core/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'select_cuisine_modal_event.dart';
part 'select_cuisine_modal_state.dart';

class SelectCuisineModalBloc extends Bloc<SelectCuisineModalEvent, SelectCuisineModalState> {
  final AuthRepository _accountRepository = AuthRepository();
  final AuthRepository _authRepository = AuthRepository();
  SelectCuisineModalBloc()
    : super(
        SelectCuisineModalState(
          model: ActiveCuisineListModel(cuisine: [], success: false, locale: ''),
        ),
      ) {
    on<SelectCuisineModalInitialEvent>(_onSelectCuisineModalInitialEvent);
    on<SelectCuisineModalSelectEvent>(_onSelectCuisineModalSelectEvent);
    on<SelectCuisineModalSaveEvent>(_onSelectCuisineModalSaveEvent);
  }

  FutureOr<void> _onSelectCuisineModalInitialEvent(SelectCuisineModalInitialEvent event, Emitter<SelectCuisineModalState> emit) async {
    try {
      await _authRepository.saveEvent('visited_screen', {"screen": "cuisine_modal"}, 'cuisine_modal_screen', 'cuisine_modal_screen');
      emit(state.copyWith(status: SelectCuisineModalStatus.loading, cuisineIds: event.cuisine));
      DioApiResponse response = await _accountRepository.getActiveCuisine();
      if (response.errorType == NetErrorType.none) {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: SelectCuisineModalStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          final String locale = await _authRepository.getLocale();
          ActiveCuisineListModel data = ActiveCuisineListModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, status: data.cuisine!.isEmpty ? SelectCuisineModalStatus.empty : SelectCuisineModalStatus.success));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SelectCuisineModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SelectCuisineModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSelectCuisineModalSelectEvent(SelectCuisineModalSelectEvent event, Emitter<SelectCuisineModalState> emit) async {
    List<String> savedCuisine = <String>[];
    savedCuisine = state.cuisineIds;
    if (savedCuisine.contains(event.id)) {
      savedCuisine.removeWhere((element) => element == event.id);
    } else {
      savedCuisine.add(event.id);
    }
    emit(state.copyWith(cuisineIds: [...savedCuisine]));
  }

  FutureOr<void> _onSelectCuisineModalSaveEvent(SelectCuisineModalSaveEvent event, Emitter<SelectCuisineModalState> emit) async {
    List<String> cuisineName = <String>[];
    cuisineName.clear();
    for (var element in state.model.cuisine!) {
      if (state.cuisineIds.contains(element.id!)) {
        cuisineName.add(element.name!);
      }
    }
    emit(state.copyWith(cuisineNames: cuisineName, status: SelectCuisineModalStatus.saved));
  }
}
