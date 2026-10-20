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

import 'package:user/app/core/config/api_endpoints.dart';
import 'package:user/app/core/config/api_request_service.dart';
import 'package:user/app/core/config/shared_pref_keys.dart';
import 'package:user/app/core/models/local_search_history_model.dart';
import 'package:user/app/env.dart';
import 'package:user/app/services/shared_pref.dart';
import 'package:user/app/services/uuid_generator.dart';

class LocationRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiExternalRequestService _apiExternalRequestService = ApiExternalRequestService();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<void> saveLocation(double latitude, double longitude, String address, String addressTitle) async {
    await _sharedPreferencesManager.putDouble(SharedPreferencesKey.publicKeys.userLatitude, latitude);
    await _sharedPreferencesManager.putDouble(SharedPreferencesKey.publicKeys.userLongitude, longitude);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.userAddress, address);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.userAddressTitle, addressTitle);
  }

  Future<void> saveDeliveryLocation(double latitude, double longitude, String address, String addressTitle, String addressId) async {
    await _sharedPreferencesManager.putDouble(SharedPreferencesKey.publicKeys.userLatitude, latitude);
    await _sharedPreferencesManager.putDouble(SharedPreferencesKey.publicKeys.userLongitude, longitude);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.userAddress, address);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.userAddressTitle, addressTitle);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.publicKeys.checkoutAddressId, addressId);
  }

  Future<bool> haveLocation() async {
    bool userLatitude = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.userLatitude);
    bool userLongitude = await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.userLongitude);
    if (userLatitude && userLongitude) {
      return true;
    }
    return false;
  }

  Future<String> getAddressTitle() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.userAddressTitle) ?? '';
  }

  Future<String> getFullAddress() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.userAddress) ?? '';
  }

  Future<DioApiResponse> getGooglePlacesResults(String searchValue) async {
    final String endPoint = '${ApiEndPoints.externalRequest.googlePlaces}?input=$searchValue&key=${Environments.googleMapsKey}&sessiontoken=${Uuid().generateV4()}&types=(regions)';
    return await _apiExternalRequestService.getExternal(endPoint);
  }

  Future<void> saveLocalSearchHistory(List<LocalSearchHistoryModel> searchItem) async {
    List<String> searchResults = <String>[];
    for (var element in searchItem) {
      searchResults.add(jsonEncode(element));
    }
    _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.localSearchHistory, searchResults);
  }

  Future<List<LocalSearchHistoryModel>> getLocalSearchHistory() async {
    List<String>? searchResults = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.localSearchHistory)) {
      searchResults = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.localSearchHistory);
    }

    List<LocalSearchHistoryModel> searchItems = <LocalSearchHistoryModel>[];
    for (var element in searchResults!) {
      var items = jsonDecode(element);
      searchItems.add(LocalSearchHistoryModel.fromJson(items));
    }
    return searchItems;
  }

  Future<double> userLatitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.userLatitude) ?? 0;
  }

  Future<double> userLongitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.userLongitude) ?? 0;
  }

  Future<DioApiResponse> getMyAddressList(String uid) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyAddresses}$uid');
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }
}
