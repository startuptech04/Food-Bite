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

import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/core/models/request/tiffin_subscription_purchaser_history_request_model.dart';
import 'package:vendor/app/core/models/request/tiffin_subscription_request_model.dart';
import 'package:vendor/app/core/models/request/tiffin_subscription_update_status_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

final class TiffinSubscriptionRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<String> getUserId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> getMyTiffinSubscription(String vendorId, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMySubscriptionPackages}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> getTiffinSubscriptionFoodList(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getTiffinSubscriptionFoodList}$vendorId');
  }

  Future<DioApiResponse> saveTiffinSubscription(TiffinSubscriptionRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveTiffinSubscription, body: param);
  }

  Future<DioApiResponse> getTiffinSubscriptionInfo(String id, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getTiffinSubscriptionInfo}$id/$vendorId');
  }

  Future<DioApiResponse> updateTiffinSubscription(String id, TiffinSubscriptionRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateTiffinSubscription}$id', body: param);
  }

  Future<DioApiResponse> updateTiffinSubscriptionStatus(String id, UpdateTiffinSubscriptionStatusModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateTiffinSubscriptionStatus}$id', body: param);
  }

  Future<DioApiResponse> deleteTiffinSubscription(String id) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteTiffinSubscription}$id');
  }

  Future<DioApiResponse> getPurchaserHistory(TiffinSubscriptionPurchaserHistoryRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getTiffinSubscriptionPurchaserHistory, body: param);
  }

  Future<DioApiResponse> getPurchaseHistoryDetail(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getTiffinSubscriptionPurchaseHistoryDetail}$id');
  }

  Future<DioApiResponse> callCustomer(String userId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.callCustomer}$userId');
  }
}
