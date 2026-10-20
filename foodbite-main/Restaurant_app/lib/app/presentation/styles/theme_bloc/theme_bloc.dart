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
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/services/shared_pref.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  ThemeBloc() : super(const ThemeState(isDarkTheme: false)) {
    on<ThemeInitialEvent>(_onThemeInitialEvent);
    on<ChangeThemeEvent>(changeThemeEventHandler);
  }

  FutureOr<void> changeThemeEventHandler(ChangeThemeEvent event, Emitter<ThemeState> emit) {
    if (state.isDarkTheme) {
      emit(state.copyWith(isDarkTheme: false));
      _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.isDark, false);
    } else {
      emit(state.copyWith(isDarkTheme: true));
      _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.isDark, true);
    }
  }

  Future<void> _onThemeInitialEvent(ThemeInitialEvent event, Emitter<ThemeState> emit) async {
    final isDarkTheme = await (_sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isDark));
    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }
}
