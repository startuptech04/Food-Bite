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

import 'package:driver/app/core/config/api_endpoints.dart';
import 'package:driver/app/core/config/api_request_service.dart';
import 'package:driver/app/core/config/shared_pref_keys.dart';
import 'package:driver/app/core/models/request/driver_deliver_order_request_model.dart';
import 'package:driver/app/core/models/request/driver_pickup_order_request_model.dart';
import 'package:driver/app/core/models/request/driver_reach_customer_request_model.dart';
import 'package:driver/app/core/models/request/near_me_trending_restaurants_request_model.dart';
import 'package:driver/app/core/models/request/notification_list_request_model.dart';
import 'package:driver/app/core/models/request/order_list_request_model.dart';
import 'package:driver/app/core/models/request/order_proof_request_model.dart';
import 'package:driver/app/core/models/request/update_geo_location_request_model.dart';
import 'package:driver/app/services/shared_pref.dart';
import 'package:image_picker/image_picker.dart';

class FeedsRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<double> driverLatitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.driverLatitude) ?? 0;
  }

  Future<double> driverLongitude() async {
    return await _sharedPreferencesManager.getDouble(SharedPreferencesKey.publicKeys.driverLongitude) ?? 0;
  }

  Future<String> driverId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> getTrendingRestaurants(NearMeTrendingRestaurantsRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getTrendingRestaurantsNearDriver, body: param);
  }

  Future<String> getRefreshToken() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.authRefreshToken) ?? '';
  }

  Future<DioApiResponse> logout(String refreshToken) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.logout, body: {'refreshToken': refreshToken});
  }

  void onLogoutSuccess() {
    _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authRefreshToken);
    _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authToken);
    _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.uid);
  }

  Future<DioApiResponse> getOfflineMessageList() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.offlineMessageList);
  }

  Future<DioApiResponse> goOffline(String uid, String reasonId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.goOffline}$uid/$reasonId');
  }

  Future<DioApiResponse> goOnline(String uid) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.goOnline}$uid');
  }

  Future<DioApiResponse> getActiveOrder(String uid) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.activeOrder}$uid');
  }

  Future<DioApiResponse> googleDirection(double driverLat, double driverLng, double restLat, double restLng) async {
    return await _apiRequestService.googleDirection(driverLat, driverLng, restLat, restLng);
  }

  Future<DioApiResponse> getOrderDetails(String orderId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.orderDetails}$orderId');
  }

  Future<DioApiResponse> driverReachRestaurant(String orderId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.driverReachedRestaurant}$orderId');
  }

  Future<DioApiResponse> uploadMediaImage(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadImageFile, uid, file);
  }

  Future<DioApiResponse> saveDeliveryPickupProof(OrderProofRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveDeliveryPickupProof, body: param);
  }

  Future<DioApiResponse> driverPickupOrder(DriverPickupOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.orderPickup, body: param);
  }

  Future<DioApiResponse> driverReachedCustomer(DriverReachCustomerRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverReachedCustomer, body: param);
  }

  Future<DioApiResponse> driverDeliverOrder(DriverOrderDeliverRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.driverDeliverOrder, body: param);
  }

  Future<DioApiResponse> updateGeoLocation(UpdateGeoLocationRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.updateMyGeoLocation, body: param);
  }

  Future<DioApiResponse> deliverymanInsight() async {
    final String uid = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.getDeliverymanInsight}$uid');
  }

  Future<DioApiResponse> orderList(OrderListRequestModel param) async {
    final String uid = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    param.uid = uid;
    return await _apiRequestService.post(ApiEndPoints.v1request.orderList, body: param);
  }

  Future<DioApiResponse> getNotificationList(NotificationListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.notificationList, body: param);
  }

  Future<DioApiResponse> readAllNotification(String user) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.readAllNotification}$user');
  }
}
