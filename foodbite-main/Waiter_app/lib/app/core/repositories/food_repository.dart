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

import 'package:waiter/app/core/config/api_endpoints.dart';
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/config/shared_pref_keys.dart';
import 'package:waiter/app/services/shared_pref.dart';

class FoodRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> waiterId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> vendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterRestaurant) ?? '';
  }

  Future<DioApiResponse> getFoodList(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getFoodList}$vendorId');
  }
}
