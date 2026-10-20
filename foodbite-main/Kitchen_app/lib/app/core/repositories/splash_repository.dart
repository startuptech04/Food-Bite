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

import 'package:kitchen/app/core/config/api_endpoints.dart';
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/config/shared_pref_keys.dart';
import 'package:kitchen/app/core/models/kitchen_owner_setting_model.dart';
import 'package:kitchen/app/core/models/request/push_notification_token_request_model.dart';
import 'package:kitchen/app/env.dart';
import 'package:kitchen/app/services/shared_pref.dart';

class SplashRepositry {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<DioApiResponse> getDefaultSetting() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getKitchenSettings);
  }

  Future<DioApiResponse> savePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.savePushNotificationToken, body: param);
  }

  Future<bool> haveAuthToken() async {
    return await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.authToken);
  }

  Future<void> saveSettings(KitchenOwnerSettingsModel ownerSettingModel) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessEmail, ownerSettingModel.settings!.email!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessMobile, ownerSettingModel.settings!.mobile!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.companyNameKey, ownerSettingModel.settings!.companyName!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySymbolKey, ownerSettingModel.settings!.currency!.symbol!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySide, ownerSettingModel.settings!.currencySide!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.ownerLoginWith, ownerSettingModel.kitchen!.ownerLoginWith!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.ownerResetPasswordWith, ownerSettingModel.kitchen!.ownerResetPasswordWith!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultCountryCode, jsonEncode(ownerSettingModel.settings!.defaultCountryCode!).toString());
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialAppleSignIn, ownerSettingModel.social!.appleSignin!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialGoogleSignIn, ownerSettingModel.social!.googleSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthClientId, ownerSettingModel.social!.googleOAuth!.googleClientId!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthServerId, ownerSettingModel.social!.googleOAuth!.googleServerId!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialFacebookSignIn, ownerSettingModel.social!.facebookSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.appLogo, ownerSettingModel.settings!.logo!);
    _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.defaultLanguage).then((value) async {
      if (value == false) {
        await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultLanguage, ownerSettingModel.defaultLocale!.code!);
      }
    });
    final String imagePath = ownerSettingModel.imagePath! != 'none' ? ownerSettingModel.imagePath! : '${Environments.apiBaseURL}storage/';
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
