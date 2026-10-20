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
import 'package:vendor/app/core/models/request/join_dining_campaign_request_model.dart';
import 'package:vendor/app/core/models/request/join_food_campaign_request_model.dart';
import 'package:vendor/app/core/models/request/join_restaurant_campaign_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class CampaignRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<bool> getPreBookingPermission() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorPreBooking) ?? false;
  }

  Future<DioApiResponse> getRestaurantCampaignNearMe(int pageSize, int currentPage, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getRestaurantCampaignNearMe}$vendorId?limit=$pageSize&page=$currentPage');
  }

  Future<DioApiResponse> leaveRestaurantCampgin(String campaignId, String vendorId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.leaveRestaurantCampaign}$campaignId/$vendorId');
  }

  Future<DioApiResponse> joinRestaurantCampgin(JoinRestaurantCampaignRequestModel body) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.joinRestaurantCampaign, body: body);
  }

  Future<DioApiResponse> getDiningCampaignNearMe(int pageSize, int currentPage, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getDiningCampaignNearMe}$vendorId?limit=$pageSize&page=$currentPage');
  }

  Future<DioApiResponse> leaveDiningCampaign(String campaignId, String vendorId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.leaveDiningCampaign}$campaignId/$vendorId');
  }

  Future<DioApiResponse> joinDiningCampaign(JoinDiningCampaignRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.joinDiningCampaign, body: param);
  }

  Future<DioApiResponse> getFoodCampaignNearMe(int pageSize, int currentPage, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getFoodCampaignNearMe}$vendorId?limit=$pageSize&page=$currentPage');
  }

  Future<DioApiResponse> getFoodCampaignDetails(String id, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getFoodCampaignDetail}$id/$vendorId');
  }

  Future<DioApiResponse> joinFoodCampgin(JoinFoodCampaignRequestModel body) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.joinFoodCampaign, body: body);
  }

  Future<DioApiResponse> leaveFoodCampgin(String campaignId, String foodId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.leaveFoodCampaign}$campaignId/$foodId');
  }
}
