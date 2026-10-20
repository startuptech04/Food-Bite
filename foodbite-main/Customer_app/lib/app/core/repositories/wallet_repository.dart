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
import 'package:user/app/core/models/request/make_wallet_payment_request_model.dart';
import 'package:user/app/core/models/request/reedem_loyalty_point_request_model.dart';
import 'package:user/app/services/shared_pref.dart';

class WalletRepositry {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> getWalletPaymentList() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getWalletPaymentList);
  }

  Future<DioApiResponse> getWalletInfo(String user, int? limit, int? page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getWalletInfo}$user?limit=$limit&page=$page');
  }

  Future<DioApiResponse> getWalletPaymentLink(MakeWalletPaymentRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getWalletPaymentLink, body: param);
  }

  Future<DioApiResponse> getLoyaltyPoints(String user) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getLoyaltyPoints}$user');
  }

  Future<DioApiResponse> redeemLoyaltyPoints(RedeemLoyaltyPointRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.redeemLoyaltyPoints, body: param);
  }
}
