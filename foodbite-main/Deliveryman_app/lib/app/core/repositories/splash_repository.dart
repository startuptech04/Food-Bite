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

import 'dart:convert';

import 'package:driver/app/core/config/api_endpoints.dart';
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/config/shared_pref_keys.dart';
import 'package:driver/app/core/models/driver_settings_model.dart';
import 'package:driver/app/core/models/request/push_notification_token_request_model.dart';
import 'package:driver/app/env.dart';
import 'package:driver/app/services/shared_pref.dart';

class SplashRepositry {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<DioApiResponse> getDefaultSetting() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getDriverSettings);
  }

  Future<DioApiResponse> savePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.savePushNotificationToken, body: param);
  }

  Future<DioApiResponse> updatePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.updatePushNotificationToken, body: param);
  }

  Future<bool> haveIntro() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.introKey);
  }

  Future<bool> haveAuthToken() async {
    return await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.authToken);
  }

  Future<bool> haveLocation() async {
    bool driverLatitude = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.driverLatitude);
    bool driverLongitude = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.driverLongitude);
    if (driverLatitude && driverLongitude) {
      return true;
    }
    return false;
  }

  Future<void> saveSettings(DriverSettingsModel driverSettingsModel) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessEmail, driverSettingsModel.settings!.email!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessMobile, driverSettingsModel.settings!.mobile!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.companyNameKey, driverSettingsModel.settings!.companyName!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySymbolKey, driverSettingsModel.settings!.currency!.symbol!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySide, driverSettingsModel.settings!.currencySide!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.driverLoginWith, driverSettingsModel.driver!.driverLoginWith!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.driverResetPasswordWith, driverSettingsModel.driver!.driverResetPasswordWith!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.selfRegistration, driverSettingsModel.driver!.selfRegistration!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultCountryCode, jsonEncode(driverSettingsModel.settings!.defaultCountryCode!).toString());
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialAppleSignIn, driverSettingsModel.social!.appleSignin!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialGoogleSignIn, driverSettingsModel.social!.googleSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthClientId, driverSettingsModel.social!.googleOAuth!.googleClientId!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthServerId, driverSettingsModel.social!.googleOAuth!.googleServerId!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialFacebookSignIn, driverSettingsModel.social!.facebookSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.appLogo, driverSettingsModel.settings!.logo!);
    _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.defaultLanguage).then((value) async {
      if (value == false) {
        await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultLanguage, driverSettingsModel.defaultLocale!.code!);
      }
    });

    final String imagePath = driverSettingsModel.imagePath! != 'none' ? driverSettingsModel.imagePath! : '${Environments.apiBaseURL}storage/';
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.mediaUrl, imagePath);
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> getNotificationBell() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.notificationBell) ?? '';
  }

  Future<void> saveNotificationBell(String notificationBell) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.notificationBell, notificationBell);
  }

  Future<bool> haveSavedLocale() async {
    return await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.defaultLanguage);
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }
}
