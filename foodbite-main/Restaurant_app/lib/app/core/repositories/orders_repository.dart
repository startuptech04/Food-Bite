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

import 'package:image_picker/image_picker.dart';
import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/core/models/request/accept_schedule_order_request_model.dart';
import 'package:vendor/app/core/models/request/asssign_driver_order_manually_request_model.dart';
import 'package:vendor/app/core/models/request/custom_date_insight_request_model.dart';
import 'package:vendor/app/core/models/request/order_handover_to_customer_request_model.dart';
import 'package:vendor/app/core/models/request/order_handover_to_driver_request_model.dart';
import 'package:vendor/app/core/models/request/order_list_request_model.dart';
import 'package:vendor/app/core/models/request/prepare_order_request_model.dart';
import 'package:vendor/app/core/models/request/order_ready_request_model.dart';
import 'package:vendor/app/core/models/request/reject_order_request_model.dart';
import 'package:vendor/app/core/models/request/remove_image_file_request_model.dart';
import 'package:vendor/app/core/models/request/restaurant_review_list_request_model.dart';
import 'package:vendor/app/core/models/request/save_order_complaints_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class OrderRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<String> userId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<DioApiResponse> getOrderList(OrderListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.getOrderList, body: param);
  }

  Future<DioApiResponse> getCancellationReasonList() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.cancellationReasonList);
  }

  Future<bool> haveOwnDriver() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorOwnDriver) ?? false;
  }

  Future<DioApiResponse> prepareOrder(PrepareOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.prepareOrder, body: param);
  }

  Future<DioApiResponse> acceptScheduleOrder(AcceptScheduleOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.acceptScheduleOrder, body: param);
  }

  Future<DioApiResponse> orderReady(OrderReadyRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.orderReady, body: param);
  }

  Future<DioApiResponse> activeDriver(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.activeDrivers}$vendorId');
  }

  Future<DioApiResponse> orderHandoverToDriver(OrderHandoverToDriverRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.handoverOrderToDriver, body: param);
  }

  Future<DioApiResponse> orderHandoverToCustomer(OrderHandoverToCustomerRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.handoverOrderToCustomer, body: param);
  }

  Future<DioApiResponse> rejectOrder(RejectOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.rejectOrder, body: param);
  }

  Future<DioApiResponse> fetchDriverNearToOrder(String orderId, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.fetchDriverNearYou}$orderId/$vendorId');
  }

  Future<DioApiResponse> assignDriverToOrderManually(AssignOrderToDriverManuallyRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.assignDriverToOrderManually, body: param);
  }

  Future<DioApiResponse> getRestaurantReviewList(RestaurantReviewListRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.reviewList, body: param);
  }

  Future<DioApiResponse> getOrderDetail(String orderId, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getOrderDetail}$orderId/$vendorId');
  }

  Future<DioApiResponse> callCustomer(String orderId, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.callCustomerFromOrder}$orderId/$vendorId');
  }

  Future<DioApiResponse> callDeliveryman(String orderId, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.callDeliverymanFromOrder}$orderId/$vendorId');
  }

  Future<DioApiResponse> getOrderDetailForComplaints(String orderId, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getOrderDetailForComplaints}$orderId/$vendorId');
  }

  Future<DioApiResponse> deleteMediaFile(RemoveImageFileRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.removeImageFile, body: param);
  }

  Future<DioApiResponse> uploadMediaImage(XFile file, String uid) async {
    return await _apiRequestService.uploadImageFile(ApiEndPoints.v1request.uploadImageFile, uid, file);
  }

  Future<DioApiResponse> saveComplaint(SaveOrderComplaintRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveOrderComplaints, body: param);
  }

  Future<DioApiResponse> temporaryCloseRestaurant(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.temporaryCloseRestaurant}$vendorId');
  }

  Future<DioApiResponse> reOpenTemporaryRestaurant(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.reOpenTemporaryRestaurant}$vendorId');
  }

  Future<DioApiResponse> orderBusinessInsight() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.orderBusinessInsight}$vendor');
  }

  Future<DioApiResponse> posBusinessInsight() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.posBusinessInsight}$vendor');
  }

  Future<DioApiResponse> tableOrderBusinessInsight() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.tableOrderBusinessInsight}$vendor');
  }

  Future<DioApiResponse> orderBusinessInsightCustom(CustomDateInsightRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.orderBusinessInsightCustom, body: param);
  }

  Future<DioApiResponse> posBusinessInsightCustom(CustomDateInsightRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.posBusinessInsightCustom, body: param);
  }

  Future<DioApiResponse> tableOrderBusinessInsightCustom(CustomDateInsightRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.tableOrderBusinessInsightCustom, body: param);
  }

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }

  Future<bool> orderSummary(String id, String locale, String path) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.download('${ApiEndPoints.v1request.orderSumary}/$id/$vendor/$locale', path);
  }

  Future<bool> orderInvoice(String id, String locale, String path) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.download('${ApiEndPoints.v1request.orderInvoice}/$id/$vendor/$locale', path);
  }

  Future<DioApiResponse> printInvoice(String orderId) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.printInvoice}$orderId/$vendor');
  }

  Future<DioApiResponse> printPOSInvoice(String orderId) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.printPOSOrderInvoice}$orderId/$vendor');
  }

  Future<DioApiResponse> printTableOrderInvoice(String orderId) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.printTableOrderInvoice}$orderId/$vendor');
  }
}
