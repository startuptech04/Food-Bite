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
import 'package:vendor/app/core/models/request/addon_request_model.dart';
import 'package:vendor/app/core/models/request/custom_category_request_model.dart';
import 'package:vendor/app/core/models/request/custom_sub_category_request_model.dart';
import 'package:vendor/app/core/models/request/food_request_model.dart';
import 'package:vendor/app/core/models/request/food_taxation_dialog_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';

class MenuRepository {
  final ApiRequestService _apiRequestService = ApiRequestService();
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();

  Future<DioApiResponse> getAddons(int pageSize, int currentPage, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyAddons}$vendorId?limit=$pageSize&page=$currentPage');
  }

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<bool> haveCustomCategory() async {
    return await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorCustomCategory) ?? false;
  }

  Future<DioApiResponse> saveAddon(AddonsRequestModel body) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.addAddons, body: body);
  }

  Future<DioApiResponse> updateAddon(String id, AddonsRequestModel body) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateAddons}$id', body: body);
  }

  Future<DioApiResponse> deleteAddon(String id) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteAddons}$id');
  }

  Future<DioApiResponse> getCategories(int customPageSize, int customCurrentPage, int mainPageSize, int mainCurrentPage, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getAllCategories}$vendorId?limit=$customPageSize&page=$customCurrentPage&mainLimit=$mainPageSize&mainPage=$mainCurrentPage');
  }

  Future<DioApiResponse> getVendorCategories(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getVendorCategories}$vendorId');
  }

  Future<DioApiResponse> updateCustomCategory(String id, CustomCategoryRequestModel body) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateVendorCategories}$id', body: body);
  }

  Future<DioApiResponse> deleteCustomCategory(String id) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteVendorCategories}$id');
  }

  Future<DioApiResponse> createCustomCategory(CustomCategoryRequestModel body) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.createVendorCategories, body: body);
  }

  Future<DioApiResponse> getSubCategories(int customPageSize, int customCurrentPage, int mainPageSize, int mainCurrentPage, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getAllSubCategories}$vendorId?limit=$customPageSize&page=$customCurrentPage&mainLimit=$mainPageSize&mainPage=$mainCurrentPage');
  }

  Future<DioApiResponse> createCustomSubCategory(CustomSubCategoryRequestModel body) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.createVendorSubCategories, body: body);
  }

  Future<DioApiResponse> updateCustomSubCategory(String id, CustomSubCategoryRequestModel body) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateVendorSubCategories}$id', body: body);
  }

  Future<DioApiResponse> deleteCustomSubCategory(String id) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteVendorSubCategories}$id');
  }

  Future<DioApiResponse> getAllMainCategory() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.getAllMainActiveCategories);
  }

  Future<DioApiResponse> getSubCategoryById(String cateId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getSubCategoriesByCategoryId}$cateId');
  }

  Future<DioApiResponse> getCustomSubCategoryById(String cateId, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getCustomSubCategories}$cateId/$vendorId');
  }

  Future<DioApiResponse> getAllMyAddonsList(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getAllMyAddons}$vendorId');
  }

  Future<DioApiResponse> createFood(FoodRequestModel body) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveFood, body: body);
  }

  Future<DioApiResponse> updateFood(String foodId, FoodRequestModel body) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateFood}$foodId', body: body);
  }

  Future<DioApiResponse> updateFoodMetaInfo(String foodId, dynamic body) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateFoodMetaInfo}$foodId', body: body);
  }

  Future<DioApiResponse> getAllFoodList(String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getFoodList}$vendorId');
  }

  Future<DioApiResponse> getFoodInfo(String foodId, String vendorId) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getFoodInfo}$foodId/$vendorId');
  }

  Future<DioApiResponse> saveFoodTaxation(String vendorId, FoodTaxationDialogRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.saveFoodTaxation, body: param);
  }

  Future<DioApiResponse> getMyFoodTaxation(String vendorId, int customPageSize, int customCurrentPage) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getMyFoodTaxation}$vendorId?limit=$customPageSize&page=$customCurrentPage');
  }

  Future<DioApiResponse> deleteFoodTaxation(String id, String vendorId) async {
    return await _apiRequestService.delete('${ApiEndPoints.v1request.deleteFoodTaxation}$id/$vendorId');
  }

  Future<DioApiResponse> updateFoodTaxation(String id, String vendorId, FoodTaxationDialogRequestModel param) async {
    return await _apiRequestService.patch('${ApiEndPoints.v1request.updateFoodTaxation}$id/$vendorId', body: param);
  }

  Future<DioApiResponse> searchMenu(String vendor, String searchQuery) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.searchMenu}$vendor/$searchQuery');
  }

  Future<DioApiResponse> getAllMyTaxation(String vendor) async {
    return await _apiRequestService.get('${ApiEndPoints.v1request.getAllTaxation}$vendor');
  }
}
