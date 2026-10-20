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
import 'package:vendor/app/core/models/dining_category_list_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_category_checklist_event.dart';
part 'dining_category_checklist_state.dart';

class DiningCategoryChecklistBloc extends Bloc<DiningCategoryChecklistEvent, DiningCategoryChecklistState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningCategoryChecklistBloc() : super(const DiningCategoryChecklistState()) {
    on<DiningCategoryChecklistInitialEvent>(_onDiningCategoryChecklistInitialEvent);
    on<DiningCategoryChecklistSelectEvent>(_onDiningCategoryChecklistSelectEvent);
    on<DiningCategoryChecklistSaveEvent>(_onDiningCategoryChecklistSaveEvent);
  }

  FutureOr<void> _onDiningCategoryChecklistInitialEvent(DiningCategoryChecklistInitialEvent event, Emitter<DiningCategoryChecklistState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_category_checklist"}, 'dining_category_checklist_screen', 'dining_category_checklist_screen');
      emit(state.copyWith(status: DiningCategoryChecklistStatus.loading));
      DioApiResponse response = await _diningBookingRepository.getDiningCategories();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        var categories = (jsonDecode(response.body) as List).map((value) => DiningCategoryListModel.fromJson(value, locale.toString())).toList();
        event.savedCategory.where((element) => element.isNotEmpty && element != '');
        emit(state.copyWith(categories: categories, savedDiningCategoryId: event.savedCategory, status: categories.isNotEmpty ? DiningCategoryChecklistStatus.success : DiningCategoryChecklistStatus.empty));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningCategoryChecklistStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningCategoryChecklistStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningCategoryChecklistSelectEvent(DiningCategoryChecklistSelectEvent event, Emitter<DiningCategoryChecklistState> emit) async {
    List<String> savedIds = <String>[];
    for (var element in state.savedDiningCategoryId) {
      savedIds.add(element);
    }
    if (savedIds.contains(event.id)) {
      savedIds.removeWhere((element) => element == event.id);
      emit(state.copyWith(savedDiningCategoryId: [...savedIds]));
    } else {
      savedIds.add(event.id);
      emit(state.copyWith(savedDiningCategoryId: [...savedIds]));
    }
  }

  FutureOr<void> _onDiningCategoryChecklistSaveEvent(DiningCategoryChecklistSaveEvent event, Emitter<DiningCategoryChecklistState> emit) async {
    List<String> savedNames = <String>[];
    for (var element in state.categories) {
      if (state.savedDiningCategoryId.contains(element.id!)) {
        savedNames.add(element.name!);
      }
    }
    state.savedDiningCategoryId.where((element) => element.isNotEmpty && element != '');
    savedNames.where((element) => element.isNotEmpty && element != '');
    emit(state.copyWith(savedDiningCategoryName: [...savedNames], savedDiningCategoryId: [...state.savedDiningCategoryId], status: DiningCategoryChecklistStatus.selected));
  }
}
