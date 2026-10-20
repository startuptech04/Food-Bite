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
import 'package:vendor/app/core/models/active_restaurant_type_list_model.dart';
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'select_restaurant_type_modal_event.dart';
part 'select_restaurant_type_modal_state.dart';

class SelectRestaurantTypeModalBloc extends Bloc<SelectRestaurantTypeModalEvent, SelectRestaurantTypeModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  SelectRestaurantTypeModalBloc()
    : super(
        SelectRestaurantTypeModalState(
          model: ActiveRestaurantTypeListResponseModel(restaurantType: [], success: false, locale: ''),
        ),
      ) {
    on<SelectRestaurantTypeModalInitialEvent>(_onSelectRestaurantTypeModalInitialEvent);
    on<SelectRestaurantTypeModalSelectEvent>(_onSelectRestaurantTypeModalSelectEvent);
    on<SelectRestaurantTypeModalSaveEvent>(_onSelectRestaurantTypeModalSaveEvent);
  }

  FutureOr<void> _onSelectRestaurantTypeModalInitialEvent(SelectRestaurantTypeModalInitialEvent event, Emitter<SelectRestaurantTypeModalState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "restaurant_type"}, 'restaurant_type_screen', 'restaurant_type_screen');
      emit(state.copyWith(status: SelectRestaurantTypeModalStatus.loading, typeIds: event.type));
      DioApiResponse response = await _accountRepository.getActiveRestaurantType();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
        if (!initialResponse.success!) {
          emit(state.copyWith(status: SelectRestaurantTypeModalStatus.failure, statusCode: 0, alertMessage: 'Something went wrong', extraMessage: ''));
        } else {
          ActiveRestaurantTypeListResponseModel data = ActiveRestaurantTypeListResponseModel.fromJson(myMap, locale.toString());
          emit(state.copyWith(model: data, status: data.restaurantType!.isEmpty ? SelectRestaurantTypeModalStatus.empty : SelectRestaurantTypeModalStatus.success));
        }
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: SelectRestaurantTypeModalStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: SelectRestaurantTypeModalStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onSelectRestaurantTypeModalSelectEvent(SelectRestaurantTypeModalSelectEvent event, Emitter<SelectRestaurantTypeModalState> emit) async {
    List<String> savedType = <String>[];
    savedType = state.typeIds;
    if (savedType.contains(event.id)) {
      savedType.removeWhere((element) => element == event.id);
    } else {
      savedType.add(event.id);
    }
    emit(state.copyWith(typeIds: [...savedType]));
  }

  FutureOr<void> _onSelectRestaurantTypeModalSaveEvent(SelectRestaurantTypeModalSaveEvent event, Emitter<SelectRestaurantTypeModalState> emit) async {
    List<String> typeNames = <String>[];
    typeNames.clear();
    for (var element in state.model.restaurantType!) {
      if (state.typeIds.contains(element.id!)) {
        typeNames.add(element.name!);
      }
    }
    emit(state.copyWith(typeNames: typeNames, status: SelectRestaurantTypeModalStatus.saved));
  }
}
