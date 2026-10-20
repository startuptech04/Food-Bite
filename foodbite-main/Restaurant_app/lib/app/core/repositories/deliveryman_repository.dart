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
import 'package:vendor/app/core/models/request/deliveryman_change_blocked_status_request_model.dart';
import 'package:vendor/app/core/models/request/deliveryman_change_hide_status_request_model.dart';
import 'package:vendor/app/core/models/request/manage_deliveryman_create_profile_request_model.dart';
import 'package:vendor/app/core/models/request/update_deliveryman_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class DeliverymanRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<DioApiResponse> getDeliverymanList(String vendor, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.deliverymanList}$vendor?limit=$limit&page=$page');
  }

  Future<DioApiResponse> updateBlockedStatus(String deliveryman, DeliverymanChangeBlockedStatusRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateDeliverymanStatus}$deliveryman', body: param);
  }

  Future<DioApiResponse> updateHideStatus(String deliveryman, DeliverymanChangeHideStatusRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateDeliverymanStatus}$deliveryman', body: param);
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<DioApiResponse> getInitialData(String vendor) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.initialDeliverymanData}$vendor');
  }

  Future<DioApiResponse> saveDeliveryman(ManageDeliverymanCreateProfileRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveDeliveryman, body: param);
  }

  Future<DioApiResponse> getDeliverymanInfo(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getDeliverymanInfo}$id');
  }

  Future<DioApiResponse> updateDEliveryman(String id, UpdateDeliverymanRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateDeliveryman}$id', body: param);
  }
}
