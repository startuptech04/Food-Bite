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
import 'package:vendor/app/core/models/api_status_response_model.dart';
import 'package:vendor/app/core/models/search_menu_response_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'search_menu_event.dart';
part 'search_menu_state.dart';

class SearchMenuBloc extends Bloc<SearchMenuEvent, SearchMenuState> {
  final MenuRepository _menuRepository = MenuRepository();
  final AccountRepository _accountRepository = AccountRepository();
  Timer? _debounce;

  SearchMenuBloc()
    : super(
        SearchMenuState(
          model: SearchMenuResponseModel(foods: [], success: false, locale: ''),
        ),
      ) {
    on<SearchMenuInitialEvent>(_onSearchMenuInitialEvent);
    on<SearchMenuSearchEvent>(_onSearchMenuSearchEvent);
    on<SearchMenuExecuteQueryEvent>(_onSearchMenuExecuteQueryEvent);
  }

  FutureOr<void> _onSearchMenuInitialEvent(SearchMenuInitialEvent event, Emitter<SearchMenuState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "search_menu_items"}, 'search_menu_items_screen', 'search_menu_items_screen');
  }

  FutureOr<void> _onSearchMenuSearchEvent(SearchMenuSearchEvent event, Emitter<SearchMenuState> emit) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      add(SearchMenuExecuteQueryEvent(query: event.searchQuery));
    });
  }

  FutureOr<void> _onSearchMenuExecuteQueryEvent(SearchMenuExecuteQueryEvent event, Emitter<SearchMenuState> emit) async {
    if (event.query.length >= 3) {
      try {
        final String vendorId = await _menuRepository.getVendorId();
        DioApiResponse response = await _menuRepository.searchMenu(vendorId, event.query);
        if (response.errorType == NetErrorType.none) {
          final String locale = await _accountRepository.getLocale();
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ApiStatusResponseModel initialResponse = ApiStatusResponseModel.fromJson(myMap);
          if (!initialResponse.success!) {
            emit(state.copyWith(status: SearchMenuStatus.empty));
          } else {
            SearchMenuResponseModel searchResult = SearchMenuResponseModel.fromJson(myMap, locale.toString());
            emit(state.copyWith(status: searchResult.foods!.isEmpty ? SearchMenuStatus.empty : SearchMenuStatus.success, model: searchResult));
          }
        } else {
          Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
          ServerErrorModel data = ServerErrorModel.fromJson(myMap);
          emit(state.copyWith(status: SearchMenuStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
        }
      } catch (e, stacktrace) {
        emit(state.copyWith(status: SearchMenuStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(e, stacktrace);
        }
      }
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
