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

import 'package:waiter/app/core/config/api_endpoints.dart';
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/config/shared_pref_keys.dart';
import 'package:waiter/app/core/models/request/push_notification_token_request_model.dart';
import 'package:waiter/app/core/models/waiter_settings_model.dart';
import 'package:waiter/app/env.dart';
import 'package:waiter/app/services/shared_pref.dart';

class SplashRepositry {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<DioApiResponse> getDefaultSetting() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getWaiterSettings);
  }

  Future<DioApiResponse> savePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.savePushNotificationToken, body: param);
  }

  Future<bool> haveAuthToken() async {
    return await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.authToken);
  }

  Future<void> saveSettings(WaiterSettingsModel waiterSettingModel) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessEmail, waiterSettingModel.settings!.email!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessMobile, waiterSettingModel.settings!.mobile!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.companyNameKey, waiterSettingModel.settings!.companyName!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySymbolKey, waiterSettingModel.settings!.currency!.symbol!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySide, waiterSettingModel.settings!.currencySide!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.waiterLoginWith, waiterSettingModel.waiter!.waiterLoginWith!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.waiterResetPasswordWith, waiterSettingModel.waiter!.waiterResetPasswordWith!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultCountryCode, jsonEncode(waiterSettingModel.settings!.defaultCountryCode!).toString());
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialAppleSignIn, waiterSettingModel.social!.appleSignin!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialGoogleSignIn, waiterSettingModel.social!.googleSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthClientId, waiterSettingModel.social!.googleOAuth!.googleClientId!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthServerId, waiterSettingModel.social!.googleOAuth!.googleServerId!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialFacebookSignIn, waiterSettingModel.social!.facebookSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.appLogo, waiterSettingModel.settings!.logo!);
    _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.defaultLanguage).then((value) async {
      if (value == false) {
        await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultLanguage, waiterSettingModel.defaultLocale!.code!);
      }
    });

    final String imagePath = waiterSettingModel.imagePath! != 'none' ? waiterSettingModel.imagePath! : '${Environments.apiBaseURL}storage/';
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.mediaUrl, imagePath);
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<bool> haveSavedLocale() async {
    return await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.defaultLanguage);
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }
}
