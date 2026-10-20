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
import 'package:vendor/app/core/models/dining_schedule_response_model.dart';
import 'package:vendor/app/core/models/request/accept_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/request/complete_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/request/dining_booking_list_request_model.dart';
import 'package:vendor/app/core/models/request/reject_dining_booking_request_model.dart';
import 'package:vendor/app/core/models/request/save_guest_availability_request_model.dart';
import 'package:vendor/app/core/models/request/update_dining_information_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class DiningBookingRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<DioApiResponse> getDiningBookingList(DiningBookingListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.diningBookingList, body: param);
  }

  Future<DioApiResponse> saveGuestAvailability(SaveGuestAvailabilityRequestModel param) async {
    final String? vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId);
    return await _apiRequestService.post('${ApiEndPoints.v1request.saveGuestAvailability}$vendorId', body: param);
  }

  Future<DioApiResponse> getGuestAvailability() async {
    final String? vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId);
    return await _apiRequestService.get('${ApiEndPoints.v1request.getGuestAvailability}$vendorId');
  }

  Future<DioApiResponse> getMyDiningSchedule() async {
    final String? vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId);
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyDiningSchedule}$vendorId');
  }

  Future<DioApiResponse> saveDiningSchedule(List<DiningScheduleItemConfigModel> body) async {
    final String? vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId);
    return await _apiRequestService.post('${ApiEndPoints.v1request.saveDiningSchedule}$vendorId', body: {"slots": body});
  }

  Future<DioApiResponse> getVendorDiningInformation() async {
    final String? vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId);
    return await _apiRequestService.get('${ApiEndPoints.v1request.getVendorDiningInformation}$vendorId');
  }

  Future<DioApiResponse> getDiningCategories() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getDiningCategories);
  }

  Future<DioApiResponse> updateDiningInformation(UpdateDiningInformationRequestModel param) async {
    final String? vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId);
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateDiningInformation}$vendorId', body: param);
  }

  Future<DioApiResponse> acceptDiningBooking(AcceptDiningBookingRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.acceptDiningBooking, body: param);
  }

  Future<DioApiResponse> getDiningBookingCancellationReason() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.diningBookingCancellationReason);
  }

  Future<DioApiResponse> rejectDiningBooking(RejectDiningBookingRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.rejectDiningBooking, body: param);
  }

  Future<DioApiResponse> completeDiningBooking(CompleteDiningBookingRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.completeDiningBooking, body: param);
  }

  Future<DioApiResponse> getDiningBookingInformation(String id, String vendor) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.diningBookingInformation}$id/$vendor');
  }

  Future<DioApiResponse> diningBookingCallCustomer(String id, String vendor) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.diningBookingCallCustomer}$id/$vendor');
  }
}
