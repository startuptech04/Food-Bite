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
import 'package:vendor/app/core/models/dining_detail_response_model.dart';
import 'package:vendor/app/core/models/dining_detail_response_model.dart' as menu_item;
import 'package:vendor/app/core/models/dining_menu_modal_response_model.dart';
import 'package:vendor/app/core/models/request/update_dining_information_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/repositories/dining_booking_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'dining_setting_event.dart';
part 'dining_setting_state.dart';

class DiningSettingBloc extends Bloc<DiningSettingEvent, DiningSettingState> {
  final DiningBookingRepository _diningBookingRepository = DiningBookingRepository();
  final AccountRepository _accountRepository = AccountRepository();
  DiningSettingBloc() : super(DiningSettingState(model: DiningDetailResponseModel(locale: ''))) {
    on<DiningSettingInitialEvent>(_onDiningSettingInitialEvent);
    on<DiningCategoryModalResponseEvent>(_onDiningCategoryModalResponseEvent);
    on<DiningMenuModalEditResponseEvent>(_onDiningMenuModalEditResponseEvent);
    on<DiningMenuModalResponseEvent>(_onDiningMenuModalResponseEvent);
    on<DiningSettingRemoveMenuEvent>(_onDiningSettingRemoveMenuEvent);
    on<DiningMenuAddPhotoEvent>(_onDiningMenuAddPhotoEvent);
    on<DiningMenuPhotoRemoveEvent>(_onDiningMenuPhotoRemoveEvent);
    on<DiningSettingSaveEvent>(_onDiningSettingSaveEvent);
  }

  FutureOr<void> _onDiningSettingInitialEvent(DiningSettingInitialEvent event, Emitter<DiningSettingState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "dining_settings"}, 'dining_settings_screen', 'dining_settings_screen');
      emit(state.copyWith(status: DiningSettingStatus.loading));
      DioApiResponse response = await _diningBookingRepository.getVendorDiningInformation();
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        DiningDetailResponseModel diningDetailResponse = DiningDetailResponseModel.fromJson(myMap, locale.toString());
        List<String> categoryIds = <String>[];
        List<String> categoryNames = <String>[];
        for (var element in diningDetailResponse.restaurant!.diningCategory!) {
          categoryIds.add(element.id!);
          categoryNames.add(element.name!);
        }
        if (categoryIds.isNotEmpty && categoryNames.isNotEmpty) {
          emit(state.copyWith(category: categoryIds.join(','), categoryName: categoryNames.join(',')));
        }
        emit(state.copyWith(status: DiningSettingStatus.success, appLocale: locale.toString(), model: diningDetailResponse));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningSettingStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningSettingStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onDiningCategoryModalResponseEvent(DiningCategoryModalResponseEvent event, Emitter<DiningSettingState> emit) async {
    emit(state.copyWith(category: event.ids, categoryName: event.names, status: DiningSettingStatus.success));
  }

  FutureOr<void> _onDiningMenuModalResponseEvent(DiningMenuModalResponseEvent event, Emitter<DiningSettingState> emit) async {
    final String locale = await _accountRepository.getLocale();
    List<menu_item.MenuTranslations> menuTranslations = <menu_item.MenuTranslations>[];
    menuTranslations.clear();
    for (var element in event.response.translations!) {
      var convertedItem = jsonEncode(element).toString();
      Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
      menu_item.MenuTranslations savedData = menu_item.MenuTranslations.fromJson(myMap);
      menuTranslations.add(savedData);
    }
    String displayName = '';
    if (locale.isNotEmpty && event.response.translations!.isNotEmpty) {
      final int localeIndex = event.response.translations!.indexWhere((tLocale) => tLocale.code! == locale);
      if (localeIndex != -1) {
        if (event.response.translations![localeIndex].value!.isNotEmpty) {
          displayName = event.response.translations![localeIndex].value!;
        }
      }
    }
    DiningMenuConfigModel newMenu = DiningMenuConfigModel(name: event.response.name!, displayName: displayName, photos: event.response.photos, translations: menuTranslations, locale: locale.toString());
    state.model.menuDetail!.add(newMenu);
    emit(state.copyWith(model: state.model));
  }

  FutureOr<void> _onDiningMenuModalEditResponseEvent(DiningMenuModalEditResponseEvent event, Emitter<DiningSettingState> emit) async {
    final String locale = await _accountRepository.getLocale();
    final int index = state.model.menuDetail!.indexWhere((element) => element.name == event.oldName);
    if (index != -1) {
      List<menu_item.MenuTranslations> menuTranslations = <menu_item.MenuTranslations>[];
      menuTranslations.clear();
      for (var element in event.response.translations!) {
        var convertedItem = jsonEncode(element).toString();
        Map<String, dynamic>? myMap = jsonDecode(convertedItem) as Map<String, dynamic>;
        menu_item.MenuTranslations savedData = menu_item.MenuTranslations.fromJson(myMap);
        menuTranslations.add(savedData);
      }
      String displayName = '';
      if (locale.isNotEmpty && event.response.translations!.isNotEmpty) {
        final int localeIndex = event.response.translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (event.response.translations![localeIndex].value!.isNotEmpty) {
            displayName = event.response.translations![localeIndex].value!;
          }
        }
      }
      state.model.menuDetail![index].name = event.response.name!;
      state.model.menuDetail![index].displayName = displayName;
      state.model.menuDetail![index].photos = event.response.photos!;
      state.model.menuDetail![index].translations = menuTranslations;
      emit(state.copyWith(model: state.model));
    }
  }

  FutureOr<void> _onDiningSettingRemoveMenuEvent(DiningSettingRemoveMenuEvent event, Emitter<DiningSettingState> emit) async {
    state.model.menuDetail!.removeWhere((element) => element.name == event.name);
    emit(state.copyWith(model: state.model));
  }

  FutureOr<void> _onDiningMenuAddPhotoEvent(DiningMenuAddPhotoEvent event, Emitter<DiningSettingState> emit) async {
    state.model.diningPhotos!.add(event.image);
    emit(state.copyWith(model: state.model));
  }

  FutureOr<void> _onDiningMenuPhotoRemoveEvent(DiningMenuPhotoRemoveEvent event, Emitter<DiningSettingState> emit) async {
    state.model.diningPhotos!.removeWhere((element) => element == event.photo);
    emit(state.copyWith(model: state.model));
  }

  FutureOr<void> _onDiningSettingSaveEvent(DiningSettingSaveEvent event, Emitter<DiningSettingState> emit) async {
    try {
      emit(state.copyWith(status: DiningSettingStatus.updateStart));
      UpdateDiningInformationRequestModel param = UpdateDiningInformationRequestModel(categories: state.category, photos: state.model.diningPhotos!, menu: state.model.menuDetail!);
      DioApiResponse response = await _diningBookingRepository.updateDiningInformation(param);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: DiningSettingStatus.updateSuccess));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: DiningSettingStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: DiningSettingStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
