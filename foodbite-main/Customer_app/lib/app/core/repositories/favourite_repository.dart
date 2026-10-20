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

import 'package:user/app/core/config/api_endpoints.dart';
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/config/shared_pref_keys.dart';
import 'package:user/app/core/models/request/favourite_foods_request_model.dart';
import 'package:user/app/core/models/request/favourite_restaurants_request_model.dart';
import 'package:user/app/services/shared_pref.dart';

class FavouriteRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> userRole() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.userRole) ?? '';
  }

  Future<DioApiResponse> getFavouriteRestaurants(FavouriteRestaurantRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.favouriteRestaurants, body: param);
  }

  Future<DioApiResponse> getFavouriteFoods(FavouriteFoodsRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.favouriteFoods, body: param);
  }

  Future<DioApiResponse> deleteFavouriteRestaurant(String userId, String restaurantId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteFavouriteRestaurant}$restaurantId/$userId');
  }

  Future<DioApiResponse> deleteFavouriteFood(String userId, String foodId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteFavouriteFood}$foodId/$userId');
  }
}
