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
import 'package:vendor/app/core/models/request/create_outlet_request_model.dart';
import 'package:vendor/app/core/models/request/update_outlet_request_model.dart';
import 'package:vendor/app/core/models/request/update_outlet_status_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class OutletRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<DioApiResponse> getOutletList(String vendorId, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.outletList}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> updateOutletStatus(String outletId, OutletUpdateStatusRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateOutletStatus}$outletId', body: param);
  }

  Future<DioApiResponse> getBasicDataForNewOutlet() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getBasicDetailForNewOutlet);
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<DioApiResponse> saveOutlet(CreateOutletRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveOutlet, body: param);
  }

  Future<DioApiResponse> getOutletInfo(String outletId, String vendoId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getOutletInfo}$outletId/$vendoId');
  }

  Future<DioApiResponse> updateOutletInfo(String outletId, UpdateOutletRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateOutlet}$outletId', body: param);
  }
}
