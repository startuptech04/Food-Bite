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
import 'package:vendor/app/core/models/request/complete_table_order_request_model.dart';
import 'package:vendor/app/core/models/request/create_or_update_restaurant_table_request_model.dart';
import 'package:vendor/app/core/models/request/update_restaurant_table_status_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class TableOrderRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<DioApiResponse> getTableList(String vendorId, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getRestaurantTableList}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> createRestaurantTable(CreateOrUpdateRestaurantTableRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveRestaurantTable, body: param);
  }

  Future<DioApiResponse> updateRestaurantTable(String tableId, CreateOrUpdateRestaurantTableRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateRestaurantTable}$tableId', body: param);
  }

  Future<DioApiResponse> updateRestaurantTableStatus(String tableId, UpdateRestaurantTableStatusRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateRestaurantTableStatus}$tableId', body: param);
  }

  Future<DioApiResponse> deleteRestaurantTable(String tableId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteRestaurantTable}$tableId');
  }

  Future<DioApiResponse> onGoingTableOrder() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.onGoingTableOrders}$vendor');
  }

  Future<DioApiResponse> onGoingTableOrderDetail(String tableId) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.onGoingTableOrderDetail}$vendor/$tableId');
  }

  Future<DioApiResponse> deleteTableOrderCartItem(String id) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteTableOrderCartItem}$vendor/$id');
  }

  Future<DioApiResponse> completeTableOrder(CompleteTableOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.completeTableOrder, body: param);
  }

  Future<DioApiResponse> completedTableOrderList(int limit, int page) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.completedTableOrderList}$vendor?limit=$limit&page=$page');
  }

  Future<DioApiResponse> tableOrderDetail(String id) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.tableOrderDetail}$vendor/$id');
  }

  Future<DioApiResponse> tableQrDetail() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.tableQrDetail}$vendor');
  }
}
