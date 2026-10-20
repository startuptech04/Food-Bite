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
import 'package:driver/app/core/models/request/chat_conversion_request_model.dart';
import 'package:driver/app/core/models/request/load_more_chat_conversion_request_model.dart';
import 'package:driver/app/core/models/request/send_chat_message_request_model.dart';
import 'package:driver/app/core/models/request/support_chat_convertion_request_model.dart';
import 'package:driver/app/services/shared_pref.dart';

class ChatRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> authRole() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverRole) ?? '';
  }

  Future<DioApiResponse> fetchChatMessages(ChatConversionRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.fetchChatMessages, body: param);
  }

  Future<DioApiResponse> sendChatMessage(SendChatMessageRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.sendChatMessage, body: param);
  }

  Future<DioApiResponse> getChatList(String userId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.chatList}$userId');
  }

  Future<DioApiResponse> getChatConversion(LoadMoreChatConversionRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getChatConversion, body: param);
  }

  Future<DioApiResponse> getSupportChatList(String userId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.supportChatList}$userId');
  }

  Future<DioApiResponse> fetchSupportChatMessages(SupportChatConvertionRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.fetchSupportChatMessages, body: param);
  }

  Future<DioApiResponse> sendSupportChatMessage(SendChatMessageRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.sendSupportChatMessage, body: param);
  }

  Future<DioApiResponse> getSupportChatConversion(LoadMoreChatConversionRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getSupportChatConversion, body: param);
  }

  Future<String> firstName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverFirstName) ?? '';
  }

  Future<String> lastName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverLastName) ?? '';
  }

  Future<String> driverCover() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.driverCover) ?? '';
  }
}
