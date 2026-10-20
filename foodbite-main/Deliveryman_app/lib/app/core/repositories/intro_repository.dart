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

class IntroRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<void> saveIntro() async {
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.introKey, true);
  }

  Future<void> saveLocation(double latitude, double longitude) async {
    await _sharedPreferencesManager.putDouble(SharedPreferencesKey.publicKeys.driverLatitude, latitude);
    await _sharedPreferencesManager.putDouble(SharedPreferencesKey.publicKeys.driverLongitude, longitude);
  }
}
