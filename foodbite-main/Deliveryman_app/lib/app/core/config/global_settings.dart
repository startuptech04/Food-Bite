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

import 'package:driver/app/core/config/shared_pref_keys.dart';
import 'package:driver/app/services/shared_pref.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GlobalSettings {
  static String globalCurrencySide = '';
  static String globalCurrencySymbol = '';

  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  Future<void> init() async {
    try {
      final currencySide = await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.currencySide);
      final currencySymbol = await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.currencySymbolKey);
      globalCurrencySide = currencySide ?? '';
      globalCurrencySymbol = currencySymbol ?? '';
    } catch (e, stacktrace) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
      throw Exception(e);
    }
  }
}
