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
import 'package:vendor/app/core/models/request/dining_coupon_info_request_model.dart';
import 'package:vendor/app/core/models/request/dining_coupon_request_model.dart';
import 'package:vendor/app/core/models/request/order_coupon_info_request_model.dart';
import 'package:vendor/app/core/models/request/order_coupon_new_request_model.dart';
import 'package:vendor/app/core/models/request/update_dining_coupon_meta_request_model.dart';
import 'package:vendor/app/core/models/request/update_order_coupon_meta_info_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

final class CouponRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<String> getUserId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> getOrderCouponList(String vendorId, String userId, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getOrderCouponList}?limit=$limit&page=$page&vendorId=$vendorId&userId=$userId');
  }

  Future<DioApiResponse> saveOrderCoupon(OrderCouponNewRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveOrderCoupon, body: param);
  }

  Future<DioApiResponse> updateOrderCouponMetaInfo(String id, UpdateOrderCouponMetaInfoRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateOrderCouponMetaInfo}$id', body: param);
  }

  Future<DioApiResponse> deleteOrderCoupon(String id, String userId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteOrderCoupon}$id/$userId');
  }

  Future<DioApiResponse> getOrderCouponInfo(OrderCouponInfoRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getOrderCouponInfo, body: param);
  }

  Future<DioApiResponse> updateOrderCoupon(String id, OrderCouponNewRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateOrderCoupon}$id', body: param);
  }

  Future<DioApiResponse> getDiningCouponList(String vendorId, String userId, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getDiningCouponList}?limit=$limit&page=$page&vendorId=$vendorId&userId=$userId');
  }

  Future<DioApiResponse> saveDiningCoupon(DiningCouponRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveDiningCoupon, body: param);
  }

  Future<DioApiResponse> updateDiningCouponMetaInfo(String id, UpdateDiningCouponMetaRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateDiningCouponMetaInfo}$id', body: param);
  }

  Future<DioApiResponse> deleteDiningCoupon(String id, String userId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteDiningCoupn}$id/$userId');
  }

  Future<DioApiResponse> getDiningCouponInfo(DiningCouponInfoRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getDiningCouponInfo, body: param);
  }

  Future<DioApiResponse> updateDiningCoupon(String id, DiningCouponRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateDiningCoupon}$id', body: param);
  }
}
