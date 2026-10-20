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

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/core/models/request/add_expense_request_model.dart';
import 'package:vendor/app/core/models/request/create_kitchen_owner_request_model.dart';
import 'package:vendor/app/core/models/request/feedback_form_request_model.dart';
import 'package:vendor/app/core/models/request/notification_list_request_model.dart';
import 'package:vendor/app/core/models/request/renew_subscription_package_request_model.dart';
import 'package:vendor/app/core/models/request/report_emergency_request_model.dart';
import 'package:vendor/app/core/models/request/restaurant_update_detail_request_model.dart';
import 'package:vendor/app/core/models/request/update_kitchen_owner_info_request_model.dart';
import 'package:vendor/app/core/models/request/update_kitchen_owner_status_request_model.dart';
import 'package:vendor/app/core/models/request/update_locale_request_model.dart';
import 'package:vendor/app/core/models/request/update_menu_and_photo_request_model.dart';
import 'package:vendor/app/core/models/request/update_user_profile_request_model.dart';
import 'package:vendor/app/core/models/slots_list_model.dart';
import 'package:vendor/app/core/models/vendor_settings_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vendor/app/services/shared_pref.dart';

class AccountRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<void> saveEvent(String eventName, Map<String, String> eventParam, String screenClasss, String screenName) async {
    if (!kIsWeb) {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.logEvent(name: eventName, parameters: eventParam);
      await analytics.logScreenView(screenClass: screenClasss, screenName: screenName);
    }
  }

  Future<DioApiResponse> logout(String refreshToken) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.logout, body: {'refreshToken': refreshToken});
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<String> vendorName() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorName) ?? '';
  }

  Future<String> vendorAddress() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorAddress) ?? '';
  }

  Future<String> vendorLogo() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorLogo) ?? '';
  }

  Future<String> getRefreshToken() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.authRefreshToken) ?? '';
  }

  Future<void> onLogoutSuccess() async {
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authRefreshToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authToken);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.authRole);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.uid);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorId);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorPOS);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorOwnDriver);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorPromote);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorCustomCategory);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorMultiOutlet);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorPreBooking);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorTableOrder);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorTiffinSubscription);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorOwnWaiter);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorOwnKitchen);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorName);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorAddress);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorLogo);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorRating);
    await _sharedPreferencesManager.clearKey(SharedPreferencesKey.authKeys.vendorBusinessType);
  }

  Future<DioApiResponse> getMySlots() async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMySlots}$vendorId');
  }

  Future<DioApiResponse> updateMySlots(List<TimeSlotList> body) async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateMySlots}$vendorId', body: {"slots": body});
  }

  Future<bool> getPreBookingPermission() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorPreBooking) ?? false;
  }

  Future<bool> getDeliverymanPermission() async {
    final bool ownDeliveryman = await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorOwnDriver) ?? false;
    if (ownDeliveryman == true) {
      return true;
    }
    return false;
  }

  Future<bool> getTiffinSubscriptionPermission() async {
    final bool tiffinSubscription = await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorTiffinSubscription) ?? false;
    return tiffinSubscription;
  }

  Future<bool> getWaiterPermission() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorOwnWaiter) ?? false;
  }

  Future<bool> getKitchenPermission() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorOwnKitchen) ?? false;
  }

  Future<bool> getTableOrderPermission() async {
    final bool tableOrderPermission = await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorTableOrder) ?? false;
    return tableOrderPermission;
  }

  Future<String> vendorBusinessType() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorBusinessType) ?? '';
  }

  Future<String> getAuthRole() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.authRole) ?? '';
  }

  Future<bool> getOutletPermission() async {
    final bool outletPermission = await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorMultiOutlet) ?? false;
    return outletPermission;
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }

  Future<bool> currentTheme() async {
    final isDarkTheme = await (_sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isDark)) ?? false;
    return isDarkTheme;
  }

  Future<String> getDefaultCountryCode() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultCountryCode) ?? '';
  }

  Future<DioApiResponse> submitFeedbackForm(FeedbackFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveFeedbackForm, body: param);
  }

  Future<List<AppDefaultCountryCodeConfigModel>> getCountryList() async {
    final jsonString = await rootBundle.loadString(AssetsUrl.localURL.countryCodeList);
    final listOfJsonElements = jsonDecode(jsonString) as List;
    return listOfJsonElements.map((jsonElement) => AppDefaultCountryCodeConfigModel.fromJson(jsonElement)).toList();
  }

  Future<DioApiResponse> submitReportEmergencyForm(ReportEmergencyFormRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveReportEmergencyForm, body: param);
  }

  Future<DioApiResponse> getMenuAndPhotos(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMenuAndPhotos}$vendorId');
  }

  Future<DioApiResponse> updateMenuAndPhotos(String vendorId, UpdateMenuAndPhotoRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateMenuAndPhotos}$vendorId', body: param);
  }

  Future<DioApiResponse> getRestaurantDetailForUpdate(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getRestaurantDetailForUpdate}$vendorId');
  }

  Future<DioApiResponse> getActiveCuisine() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getActiveCuisine);
  }

  Future<DioApiResponse> getActiveRestaurantType() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getActiveRestaurantType);
  }

  Future<DioApiResponse> getActiveRestaurantFacility() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getActiveRestaurantFacility);
  }

  Future<DioApiResponse> updateRestaurantDetail(String id, RestaurantDetailUpdateRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateRestaurantDetail}$id', body: param);
  }

  Future<void> updateRestaurantDetailLocal(String name, String address, String logo) async {
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorName, name);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorAddress, address);
    await _sharedPreferencesManager.putString(SharedPreferencesKey.authKeys.vendorLogo, logo);
  }

  Future<DioApiResponse> getMyProfile(String id) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyProfile}$id');
  }

  Future<DioApiResponse> uploadMediaImage(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadImageFile, uid, file);
  }

  Future<DioApiResponse> updateMyProfile(String id, UpdateUserProfileRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateMyProfile}$id', body: param);
  }

  Future<DioApiResponse> getVendorSubscriptionStatus() async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.vendorSubscriptionStatus}$vendorId');
  }

  Future<DioApiResponse> getSubscriptionInfo() async {
    final String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.subscriptionInfo}$vendorId');
  }

  Future<DioApiResponse> renewSubscriptionPackage(RenewSubscriptionPackageRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.renewSubscription, body: param);
  }

  Future<DioApiResponse> addExpense(AddExpenseRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.addExpense, body: param);
  }

  Future<DioApiResponse> getInitialExpenseReport(int pageSize, int currentPage, String vendorId, String type) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.expenseInitialData}?restaurant=$vendorId&limit=$pageSize&page=$currentPage&type=$type');
  }

  Future<DioApiResponse> getExpenseList(int pageSize, int currentPage, String vendorId, String type) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.expenseList}?restaurant=$vendorId&limit=$pageSize&page=$currentPage&type=$type');
  }

  Future<String> appLogo() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.appLogo) ?? '';
  }

  Future<DioApiResponse> createKitchenOwner(CreateKitchenOwnerRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.createKitchenOwner, body: param);
  }

  Future<DioApiResponse> getKitchenOwnerList(String vendor, int limit, int page) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.kitchenOwnerList}$vendor?limit=$limit&page=$page');
  }

  Future<DioApiResponse> getKitchenOwnerInfo(String kitchenId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.kitchenOwnerInfo}$kitchenId');
  }

  Future<DioApiResponse> updateKitchenOwnerInfo(String userId, UpdateKitchenOwnerInfoRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateKitchenOwnerInfo}$userId', body: param);
  }

  Future<DioApiResponse> updateKitchenOwnerStatus(String kitchenId, UpdateKitchenOwnerStatusRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateKitchenOwnerStatus}$kitchenId', body: param);
  }

  Future<DioApiResponse> getNotificationList(NotificationListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.notificationList, body: param);
  }

  Future<DioApiResponse> readAllNotification(String user) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.readAllNotification}$user');
  }

  Future<bool> isGoogleLoggedIn() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isGoogleLoggedIn) ?? false;
  }

  Future<bool> isFacebookLoggedIn() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.publicKeys.isFacebookLoggedIn) ?? false;
  }

  Future<DioApiResponse> updateLocale(UpdateLocaleRequestModel param) async {
    return await _apiRequestService.patch(ApiEndPoints.v1request.updateUserLocale, body: param);
  }
}
