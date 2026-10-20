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
import 'package:user/app/core/models/request/save_address_request_model.dart';
import 'package:user/app/core/models/request/user_address_list_from_restaurant_request_model.dart';
import 'package:user/app/services/shared_pref.dart';

class AddressRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> saveAddress(SaveAddressRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveAddress, body: param);
  }

  Future<DioApiResponse> updateAddress(String id, SaveAddressRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAddress}$id', body: param);
  }

  Future<DioApiResponse> getMyAddressList(String uid) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyAddresses}$uid');
  }

  Future<DioApiResponse> deleteMyAddress(String uid) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteAddress}$uid');
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<double> userLatitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.userLatitude) ?? 0;
  }

  Future<double> userLongitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.userLongitude) ?? 0;
  }

  Future<DioApiResponse> getMyAddressListFromRestaurant(UserAddressListFromRestaurantRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getMyAddressListFromRestaurant, body: param);
  }
}
