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

import 'package:bloc/bloc.dart';
import 'package:driver/app/core/config/shared_pref_keys.dart';
import 'package:driver/app/services/shared_pref.dart';
import 'package:driver/app/env.dart';

part 'app_localization_event.dart';
part 'app_localization_state.dart';

class AppLocalizationBloc extends Bloc<AppLocalizationEvent, AppLocalizationState> {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  AppLocalizationBloc() : super(const AppLocalizationState(appLanguage: Environments.defaultLanguage)) {
    on<AppLocalizationInitialEvent>(_onAppLocalizationInitialEvent);
    on<ChangeAppLocalizationEvent>(_onChangeAppLocalizationEvent);
  }

  Future<void> _onAppLocalizationInitialEvent(AppLocalizationInitialEvent event, Emitter<AppLocalizationState> emit) async {
    final defaultLanguage = await (_sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage));
    emit(state.copyWith(appLanguage: defaultLanguage));
  }

  Future<void> _onChangeAppLocalizationEvent(ChangeAppLocalizationEvent event, Emitter<AppLocalizationState> emit) async {
    emit(state.copyWith(appLanguage: event.defaultLanguage));
    _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultLanguage, event.defaultLanguage);
  }
}
