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

import 'package:kitchen/app/core/config/api_endpoints.dart';
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/core/config/shared_pref_keys.dart';
import 'package:kitchen/app/core/models/request/food_request_model.dart';
import 'package:kitchen/app/services/shared_pref.dart';

class MenuRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<DioApiResponse> getFoodList() async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.foodList}$userId/');
  }

  Future<DioApiResponse> updateFoodMetaInfo(String foodId, dynamic body) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateFoodMetaInfo}$foodId', body: body);
  }

  Future<DioApiResponse> getFoodInfo(String foodId) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.getFoodInfo}$foodId/$userId');
  }

  Future<DioApiResponse> getAllMyAddonsList() async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.getAllMyAddons}$userId');
  }

  Future<DioApiResponse> updateFood(String foodId, FoodRequestModel body) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateFood}$foodId/$userId', body: body);
  }
}
