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
import 'package:vendor/app/core/models/request/change_payout_default_status_request_model.dart';
import 'package:vendor/app/core/models/request/save_payout_method_request_model.dart';
import 'package:vendor/app/core/models/request/update_payout_method_request_model.dart';
import 'package:vendor/app/core/models/request/withdrawal_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class WalletRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<DioApiResponse> walletDetail() async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.walletDetail}$vendorId');
  }

  Future<DioApiResponse> getWalletTransaction(int? limit, int? page) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.walletTransactionList}$userId?limit=$limit&page=$page');
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<DioApiResponse> getCashInHandHistory(int? limit, int? page) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.cashInHandHistoryList}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> getPosAndTableOrderCommissionHistory(int? limit, int? page) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.posAndTableOrderCommissionList}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> getCollectedCashInHandHistory(int? limit, int? page) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.collectedCashInHandHistoryList}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> payoutMethodList() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.payoutMethodList);
  }

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<DioApiResponse> savePayoutMethod(SavePayoutMethodRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.savePayoutMethod, body: param);
  }

  Future<DioApiResponse> myPayoutMethodList(int? limit, int? page) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyPayoutMethodList}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> deletePayoutMethod(String id) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deletePayoutMethod}$id/$vendorId');
  }

  Future<DioApiResponse> getPayoutMethodDetail(String id) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.payoutMethodDetail}$id/$vendorId');
  }

  Future<DioApiResponse> updatePayoutMethodDetail(UpdatePayoutMethodRequestModel param) async {
    return await _apiRequestService.patch(ApiEndPoints.v1request.updatePayoutMethodDetail, body: param);
  }

  Future<DioApiResponse> withdrawalDetail() async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.withdrawalDetail}$vendorId');
  }

  Future<DioApiResponse> withdrawalRequest(WithdrawalRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.withdrawalRequest, body: param);
  }

  Future<DioApiResponse> withdrawalHistory(int? limit, int? page) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.withdrawalHistory}$vendorId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> changeDefaultPayout(ChangePayoutDefaultStatusRequestModel param) async {
    return await _apiRequestService.patch(ApiEndPoints.v1request.updatePayoutDefaultStatus, body: param);
  }
}
