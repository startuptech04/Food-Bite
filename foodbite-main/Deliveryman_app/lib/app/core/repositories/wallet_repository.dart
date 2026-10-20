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
import 'package:driver/app/core/models/request/change_default_payout_method_request_model.dart';
import 'package:driver/app/core/models/request/save_payout_method_request_model.dart';
import 'package:driver/app/core/models/request/update_payout_method_request_model.dart';
import 'package:driver/app/core/models/request/withdrawal_request_model.dart';
import 'package:driver/app/services/shared_pref.dart';

class WalletRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<DioApiResponse> depositeDetail(int? limit, int? page) async {
    final String uid = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.depositeDetail}$uid?limit=$limit&page=$page');
  }

  Future<DioApiResponse> myPayoutMethodList(int? limit, int? page) async {
    final String uid = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyPayoutMethodList}$uid?limit=$limit&page=$page');
  }

  Future<DioApiResponse> payoutMethodList() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.payoutMethodList);
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<String> getUid() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> savePayoutMethod(SavePayoutMethodRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.savePayoutMethod, body: param);
  }

  Future<DioApiResponse> deletePayoutMethod(String id) async {
    final String uid = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deletePayoutMethod}$id/$uid');
  }

  Future<DioApiResponse> getPayoutMethodDetail(String id) async {
    final String uid = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.payoutMethodDetail}$id/$uid');
  }

  Future<DioApiResponse> updatePayoutMethodDetail(UpdatePayoutMethodRequestModel param) async {
    return await _apiRequestService.patch(ApiEndPoints.v1request.updatePayoutMethodDetail, body: param);
  }

  Future<DioApiResponse> getWalletTransaction(int? limit, int? page) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.walletTransactionList}$userId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> withdrawalDetail() async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.withdrawalDetail}$userId');
  }

  Future<DioApiResponse> withdrawalRequest(WithdrawalRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.requestWithdrawal, body: param);
  }

  Future<DioApiResponse> withdrawalHistory(int? limit, int? page) async {
    final String userId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.withdrawalHistory}$userId?limit=$limit&page=$page');
  }

  Future<DioApiResponse> changeDefaultPayoutMethod(ChangeDefaultPayoutMethodRequestModel param) async {
    return await _apiRequestService.patch(ApiEndPoints.v1request.changeDefaultPayoutMethod, body: param);
  }
}
