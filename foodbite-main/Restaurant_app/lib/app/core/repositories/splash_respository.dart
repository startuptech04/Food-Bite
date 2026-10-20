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

import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/core/models/request/push_notification_token_request_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/services/shared_pref.dart';

class SplashRepositry {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<DioApiResponse> getVendorSettings() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getVendorSettings);
  }

  Future<DioApiResponse> savePushNotificationToken(PushNotificationTokenRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.savePushNotificationToken, body: param);
  }

  Future<void> saveSettings(VendorSettingsModel vendorSettingsModel) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessEmail, vendorSettingsModel.business!.email!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.businessMobile, vendorSettingsModel.business!.mobile!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.companyNameKey, vendorSettingsModel.business!.companyName!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySymbolKey, vendorSettingsModel.business!.currency!.symbol!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.currencySide, vendorSettingsModel.business!.currencySide!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.restaurantLoginWith, vendorSettingsModel.vendor!.restaurantLoginWith!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.restaurantResetPasswordWith, vendorSettingsModel.vendor!.restaurantResetPasswordWith!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.selfRegistration, vendorSettingsModel.vendor!.selfRegistration!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialAppleSignIn, vendorSettingsModel.social!.appleSignin!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialGoogleSignIn, vendorSettingsModel.social!.googleSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthClientId, vendorSettingsModel.social!.googleOAuth!.googleClientId!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.googleOAuthServerId, vendorSettingsModel.social!.googleOAuth!.googleServerId!);
    await _sharedPreferencesManager.putBool(SharedPreferencesKey.publicKeys.socialFacebookSignIn, vendorSettingsModel.social!.facebookSignin!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.appLogo, vendorSettingsModel.business!.logo!);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultCountryCode, jsonEncode(vendorSettingsModel.business!.defaultCountryCode!).toString());
    await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.defaultLanguage).then((value) {
      if (value == false) {
        _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.defaultLanguage, vendorSettingsModel.language!.code!);
      }
    });
    final String imagePath = vendorSettingsModel.imagePath! != 'none' ? vendorSettingsModel.imagePath! : '${Environments.apiBaseURL}storage/';
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.mediaUrl, imagePath);
  }

  Future<bool> haveIntro() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.introKey) ?? false;
  }

  Future<bool> haveAuthToken() async {
    return await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.authKeys.authToken);
  }

  Future<String> getNotificationBell() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.notificationBell) ?? '';
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<void> saveNotificationBell(String notificationBell) async {
    _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.notificationBell, notificationBell);
  }

  Future<void> saveNewOrderID(String id) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.newOrderId, id);
  }

  Future<bool> haveSavedLocale() async {
    return await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.defaultLanguage);
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }
}
