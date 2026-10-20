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
import 'package:kitchen/app/core/models/request/notification_list_request_model.dart';
import 'package:kitchen/app/core/models/request/order_list_request_model.dart';
import 'package:kitchen/app/services/shared_pref.dart';

class OrderRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<DioApiResponse> orderList(OrderListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.orderList, body: param);
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> prepareOrder(String order) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.prepareOrder}$order/$userId');
  }

  Future<DioApiResponse> completeOrder(String order) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.completeOrder}$order/$userId');
  }

  Future<DioApiResponse> orderDetail(String order) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.orderDetail}$order/$userId');
  }

  Future<DioApiResponse> getNotificationList(NotificationListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.notificationList, body: param);
  }

  Future<DioApiResponse> readAllNotification(String user) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.readAllNotification}$user');
  }
}
