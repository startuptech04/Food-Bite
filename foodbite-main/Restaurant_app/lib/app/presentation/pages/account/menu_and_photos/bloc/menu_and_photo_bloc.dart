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
import 'package:vendor/app/core/models/menu_and_photo_response_model.dart';
import 'package:vendor/app/core/models/request/update_menu_and_photo_request_model.dart';
import 'package:vendor/app/core/models/server_error_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'menu_and_photo_event.dart';
part 'menu_and_photo_state.dart';

class MenuAndPhotoBloc extends Bloc<MenuAndPhotoEvent, MenuAndPhotoState> {
  final AccountRepository _accountRepository = AccountRepository();
  MenuAndPhotoBloc()
    : super(
        MenuAndPhotoState(
          model: MenuAndPhotoResponseModel(diningPhotos: [], menuDetail: [], success: false, locale: ''),
        ),
      ) {
    on<MenuAndPhotoInitialEvent>(_onMenuAndPhotoInitialEvent);
    on<MenuAndPhotoMenuModalResponseEvent>(_onMenuAndPhotoMenuModalResponseEvent);
    on<MenuAndPhotoMenuModalEditResponseEvent>(_onMenuAndPhotoMenuModalEditResponseEvent);
    on<MenuAndPhotoRemoveMenuEvent>(_onMenuAndPhotoRemoveMenuEvent);
    on<MenuAndPhotoMenuAddPhotoEvent>(_onMenuAndPhotoMenuAddPhotoEvent);
    on<MenuAndPhotoMenuPhotoRemoveEvent>(_onMenuAndPhotoMenuPhotoRemoveEvent);
    on<MenuAndPhotoSaveEvent>(_onMenuAndPhotoSaveEvent);
  }

  FutureOr<void> _onMenuAndPhotoInitialEvent(MenuAndPhotoInitialEvent event, Emitter<MenuAndPhotoState> emit) async {
    try {
      await _accountRepository.saveEvent('visited_screen', {"screen": "menu_photos"}, 'menu_photos_screen', 'menu_photos_screen');
      emit(state.copyWith(status: MenuAndPhotoStatus.loading));
      final String vendorId = await _accountRepository.getVendorId();
      DioApiResponse response = await _accountRepository.getMenuAndPhotos(vendorId);
      if (response.errorType == NetErrorType.none) {
        final String locale = await _accountRepository.getLocale();
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        MenuAndPhotoResponseModel menuResponse = MenuAndPhotoResponseModel.fromJson(myMap, locale.toString());
        emit(state.copyWith(status: MenuAndPhotoStatus.success, appLocale: locale.toString(), model: menuResponse));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MenuAndPhotoStatus.failure, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MenuAndPhotoStatus.failure, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  FutureOr<void> _onMenuAndPhotoMenuModalResponseEvent(MenuAndPhotoMenuModalResponseEvent event, Emitter<MenuAndPhotoState> emit) async {
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

  FutureOr<void> _onMenuAndPhotoMenuModalEditResponseEvent(MenuAndPhotoMenuModalEditResponseEvent event, Emitter<MenuAndPhotoState> emit) async {
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

  FutureOr<void> _onMenuAndPhotoRemoveMenuEvent(MenuAndPhotoRemoveMenuEvent event, Emitter<MenuAndPhotoState> emit) async {
    state.model.menuDetail!.removeWhere((element) => element.name == event.name);
    emit(state.copyWith(model: state.model));
  }

  FutureOr<void> _onMenuAndPhotoMenuAddPhotoEvent(MenuAndPhotoMenuAddPhotoEvent event, Emitter<MenuAndPhotoState> emit) async {
    state.model.diningPhotos!.add(event.image);
    emit(state.copyWith(model: state.model));
  }

  FutureOr<void> _onMenuAndPhotoMenuPhotoRemoveEvent(MenuAndPhotoMenuPhotoRemoveEvent event, Emitter<MenuAndPhotoState> emit) async {
    state.model.diningPhotos!.removeWhere((element) => element == event.photo);
    emit(state.copyWith(model: state.model));
  }

  FutureOr<void> _onMenuAndPhotoSaveEvent(MenuAndPhotoSaveEvent event, Emitter<MenuAndPhotoState> emit) async {
    try {
      emit(state.copyWith(status: MenuAndPhotoStatus.updateStart));
      UpdateMenuAndPhotoRequestModel param = UpdateMenuAndPhotoRequestModel(photos: state.model.diningPhotos!, menu: state.model.menuDetail!);
      final String vendorId = await _accountRepository.getVendorId();
      DioApiResponse response = await _accountRepository.updateMenuAndPhotos(vendorId, param);
      if (response.errorType == NetErrorType.none) {
        emit(state.copyWith(status: MenuAndPhotoStatus.updateSuccess));
      } else {
        Map<String, dynamic>? myMap = jsonDecode(response.body) as Map<String, dynamic>;
        ServerErrorModel data = ServerErrorModel.fromJson(myMap);
        emit(state.copyWith(status: MenuAndPhotoStatus.updateFailed, statusCode: data.code, alertMessage: data.message.toString(), extraMessage: data.extra.toString()));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(status: MenuAndPhotoStatus.updateFailed, statusCode: 0, alertMessage: e.toString(), extraMessage: ''));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
