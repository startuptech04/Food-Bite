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

import 'package:driver/app/core/config/api_endpoints.dart';
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/config/shared_pref_keys.dart';
import 'package:driver/app/core/models/order_notification_local_list_model.dart';
import 'package:driver/app/core/models/request/accept_order_request_model.dart';
import 'package:driver/app/core/models/request/driver_reject_order_request_model.dart';
import 'package:driver/app/services/shared_pref.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewOrderRepositry {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<String> getNotificationBell() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.notificationBell) ?? '';
  }

  Future<void> addNotificationInLocal(OrderNotificationLocalListModel item) async {
    try {
      List<String>? rawList = <String>[];
      if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.orderNotificationList)) {
        rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.orderNotificationList);
      }

      List<OrderNotificationLocalListModel> rawResults = <OrderNotificationLocalListModel>[];
      for (var element in rawList!) {
        var items = jsonDecode(element);
        OrderNotificationLocalListModel model = OrderNotificationLocalListModel.fromJson(items);
        rawResults.add(model);
      }
      rawResults.add(item);
      List<String> notificationInString = [];
      for (var element in rawResults) {
        notificationInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.orderNotificationList, notificationInString);
    } catch (e, stacktrace) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  Future<DioApiResponse> getOrderList(String driverId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.newOrderList}$driverId');
  }

  Future<DioApiResponse> cancellationReasonList() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.cancellationReason);
  }

  Future<DioApiResponse> acceptOrder(AcceptOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.acceptOrder, body: param);
  }

  Future<DioApiResponse> rejectOrder(DriverRejectOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.rejectOrder, body: param);
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<double> driverLatitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.driverLatitude) ?? 0;
  }

  Future<double> driverLongitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.driverLongitude) ?? 0;
  }
}
