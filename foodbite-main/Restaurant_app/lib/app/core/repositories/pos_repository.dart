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

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:vendor/app/core/config/api_endpoints.dart';
import 'package:vendor/app/core/config/api_request_service.dart';
import 'package:vendor/app/core/config/shared_pref_keys.dart';
import 'package:vendor/app/core/models/pos_food_in_cart_model.dart';
import 'package:vendor/app/core/models/request/pos_place_order_request_model.dart';
import 'package:vendor/app/services/shared_pref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PosRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
  }

  Future<bool> getPosOrderPermission() async {
    final bool posOrderPermission = await _sharedPreferencesManager.getBool(SharedPreferencesKey.authKeys.vendorPOS) ?? false;
    return posOrderPermission;
  }

  Future<DioApiResponse> getPosInitialData() async {
    String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.posInitialData}$vendorId');
  }

  Future<DioApiResponse> getPosInitialFoodSearch() async {
    String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.posInitialFoodSearch}$vendorId');
  }

  Future<DioApiResponse> getPosFoodSearch(String searchQuery) async {
    String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.posFoodSearch}$vendorId/$searchQuery');
  }

  Future<List<PosFoodInCartModel>> getRepeatList(String id) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();

    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      if (model.id == id) {
        rawResults.add(model);
      }
    }

    return rawResults;
  }

  Future<void> updateProductVariationInCartLocal(String uuid, String id, int quantity) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.uuid == uuid && element.id == id);
    if (index != -1) {
      rawResults[index].quantity = quantity;
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<String>? getProductCartEntity(String id) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      if (model.id == id) {
        rawResults.add(model);
      }
    }
    List<PosFoodInCartModel> listOfSavedItems = <PosFoodInCartModel>[];
    listOfSavedItems = rawResults.where((element) => element.id == id).toList();
    if (listOfSavedItems.length > 1) {
      return 'multiple';
    }
    return 'single';
  }

  Future<void> addToCartLocal(PosFoodInCartModel item) async {
    try {
      List<String>? rawList = <String>[];
      if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
        rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
      }
      final String appLocale = await getLocale();
      List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
      for (var element in rawList!) {
        var items = jsonDecode(element);
        PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
        rawResults.add(model);
      }
      rawResults.add(item);
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    } catch (e, stacktrace) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }

  Future<bool> checkProductInCart(String id) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      if (model.id == id) {
        rawResults.add(model);
      }
    }
    return rawResults.where((element) => element.id == id).isNotEmpty;
  }

  Future<int>? getQuantity(String id) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      if (model.id == id) {
        rawResults.add(model);
      }
    }

    List<PosFoodInCartModel> listOfSavedItems = <PosFoodInCartModel>[];
    listOfSavedItems = rawResults.where((element) => element.id == id).toList();
    int totalCount = 0;
    for (var element in listOfSavedItems) {
      totalCount = (int.parse(totalCount.toString()) + int.parse(element.quantity.toString()));
    }
    return totalCount;
  }

  Future<List<PosFoodInCartModel>> getByRestaurant() async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      double price = 0.0;
      double addonPrice = 0.0;
      double variationPrice = 0.0;

      /// Real Price ///
      double realPrice = 0.0;
      double addonRealPrice = 0.0;
      double variationRealPrice = 0.0;

      /// Real Price ///
      for (var element in model.addons!) {
        // Real Price //
        String realPriceOfAddon = (double.parse(addonRealPrice.toString()) + (double.parse(element.price.toString()))).toStringAsFixed(2);
        addonRealPrice = double.parse(realPriceOfAddon);
        // Real Price //
        if (element.haveDiscount!) {
          String price = (double.parse(addonPrice.toString()) + (double.parse(element.discountPrice.toString()))).toStringAsFixed(2);
          addonPrice = double.parse(price);
        } else {
          String price = (double.parse(addonPrice.toString()) + (double.parse(element.price.toString()))).toStringAsFixed(2);
          addonPrice = double.parse(price);
        }
      }

      for (var variation in model.variations!) {
        for (var options in variation.options!) {
          // Real Price //
          String realPriceOfVariation = (double.parse(variationRealPrice.toString()) + (double.parse(options.price.toString()))).toStringAsFixed(2);
          variationRealPrice = double.parse(realPriceOfVariation);
          // Real Price //
          if (options.haveDiscount!) {
            String price = (double.parse(variationPrice.toString()) + (double.parse(options.discountPrice.toString()))).toStringAsFixed(2);
            variationPrice = double.parse(price);
          } else {
            String price = (double.parse(variationPrice.toString()) + (double.parse(options.price.toString()))).toStringAsFixed(2);
            variationPrice = double.parse(price);
          }
        }
      }

      // Real Price //
      String realTotalPrice = (double.parse(model.price.toString()) + (double.parse(addonRealPrice.toString())) + (double.parse(variationRealPrice.toString()))).toStringAsFixed(2);
      realPrice = double.parse(realTotalPrice);
      // Real Price //

      if (model.discount! > 0) {
        String totalPrice = (double.parse(model.offerPrice.toString()) + double.parse(price.toString()) + (double.parse(addonPrice.toString())) + (double.parse(variationPrice.toString()))).toStringAsFixed(2);
        price = double.parse(totalPrice);
      } else {
        String totalPrice = (double.parse(model.price.toString()) + double.parse(price.toString()) + (double.parse(addonPrice.toString())) + (double.parse(variationPrice.toString()))).toStringAsFixed(2);
        price = double.parse(totalPrice);
      }
      String priceWithQuantity = (double.parse(price.toString()) * model.quantity!).toStringAsFixed(2);
      price = double.parse(priceWithQuantity);
      model.totalPrice = price;
      // Real Price //
      String realPriceWithQuantity = (double.parse(realPrice.toString()) * model.quantity!).toStringAsFixed(2);
      realPrice = double.parse(realPriceWithQuantity);
      model.realPrice = realPrice;
      String restItemDiscountString = (double.parse(model.realPrice.toString()) - double.parse(price.toString())).toStringAsFixed(2);
      double restItemDiscount = double.parse(restItemDiscountString);
      model.itemDiscount = restItemDiscount;
      rawResults.add(model);
    }

    return rawResults;
  }

  Future<void> updateProductQuantityInCartLocal(String id, int quantity) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.id == id);
    if (index != -1) {
      rawResults[index].quantity = quantity;
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<void> removeFromCartLocal(String id) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.id == id);
    if (index != -1) {
      rawResults.removeAt(index);
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<void> removeFromCartWithUuidLocal(String uuid, String id) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale);
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.uuid == uuid && element.id == id);
    if (index != -1) {
      rawResults.removeAt(index);
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<DioApiResponse> posOrderSetting() async {
    return await _apiRequestService.get(ApiEndPoints.v1request.posOrderSetting);
  }

  Future<DioApiResponse> posPlaceOrder(PosPlaceOrderRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.posPlaceOrder, body: param);
  }

  Future<void> removeFromCartWithRestaurant() async {
    await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, []);
  }

  Future<DioApiResponse> posOrderList(int pageSize, int currentPage) async {
    String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.posOrderList}$vendorId?limit=$pageSize&page=$currentPage');
  }

  Future<DioApiResponse> posOrderDetail(String id) async {
    String vendorId = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.vendorId) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.posOrderDetail}$id/$vendorId');
  }
}
