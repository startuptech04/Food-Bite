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

import 'package:flutter/services.dart';
import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/core/models/request/create_waiter_request_model.dart';
import 'package:vendor/app/core/models/request/update_waiter_info_request_model.dart';
import 'package:vendor/app/core/models/request/update_waiter_status_request_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class WaiterRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<DioApiResponse> createWaiter(CreateWaiterRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.createWaiter, body: param);
  }

  Future<DioApiResponse> getWaiterList(String vendor, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.waiterList}$vendor?limit=$limit&page=$page');
  }

  Future<DioApiResponse> getWaiterInfo(String waiterId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.waiterInfo}$waiterId');
  }

  Future<List<AppDefaultCountryCodeConfigModel>> getCountryList() async {
    final jsonString = await rootBundle.loadString(AssetsUrl.localURL.countryCodeList);
    final listOfJsonElements = jsonDecode(jsonString) as List;
    return listOfJsonElements.map((jsonElement) => AppDefaultCountryCodeConfigModel.fromJson(jsonElement)).toList();
  }

  Future<DioApiResponse> updateWaiterInfo(String userId, UpdateWaiterInfoRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateWaiterInfo}$userId', body: param);
  }

  Future<DioApiResponse> updateWaiterStatus(String waiterId, UpdateWaiterStatusRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateWaiterStatus}$waiterId', body: param);
  }
}
