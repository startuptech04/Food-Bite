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
import 'package:waiter/app/core/config/api_endpoints.dart';
import 'package:waiter/app/core/config/api_request_service.dart';
import 'package:waiter/app/core/config/shared_pref_keys.dart';
import 'package:waiter/app/core/models/pos_food_in_cart_model.dart';
import 'package:waiter/app/core/models/request/cart_item_request_model.dart';
import 'package:waiter/app/services/shared_pref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PosRepository {
  final SharedPreferencesManager _sharedPreferencesManager = SharedPreferencesManager();
  final ApiRequestService _apiRequestService = ApiRequestService();

  Future<String> getLocale() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.publicKeys.defaultLanguage) ?? '';
  }

  Future<String> waiterId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.uid) ?? '';
  }

  Future<String> getVendorId() async {
    return await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterRestaurant) ?? '';
  }

  Future<DioApiResponse> getTableList() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterRestaurant) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.tableList}$vendor');
  }

  Future<DioApiResponse> getFoodListForOrder() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterRestaurant) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.foodListForOrder}$vendor');
  }

  Future<bool> checkProductInCart(String id, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();

    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      if (model.id == id && model.tableId == tableId) {
        rawResults.add(model);
      }
    }
    return rawResults.where((element) => element.id == id && tableId == tableId).isNotEmpty;
  }

  Future<int>? getQuantity(String id, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      if (model.id == id && model.tableId == tableId) {
        rawResults.add(model);
      }
    }

    List<PosFoodInCartModel> listOfSavedItems = <PosFoodInCartModel>[];
    listOfSavedItems = rawResults.where((element) => element.id == id && element.tableId == tableId).toList();
    int totalCount = 0;
    for (var element in listOfSavedItems) {
      totalCount = (int.parse(totalCount.toString()) + int.parse(element.quantity.toString()));
    }
    return totalCount;
  }

  Future<String>? getProductCartEntity(String id, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();

    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      if (model.id == id && model.tableId == tableId) {
        rawResults.add(model);
      }
    }
    List<PosFoodInCartModel> listOfSavedItems = <PosFoodInCartModel>[];
    listOfSavedItems = rawResults.where((element) => element.id == id && element.tableId == tableId).toList();
    if (listOfSavedItems.length > 1) {
      return 'multiple';
    }
    return 'single';
  }

  Future<List<PosFoodInCartModel>> getRepeatList(String id, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();

    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      if (model.id == id && model.tableId == tableId) {
        rawResults.add(model);
      }
    }

    return rawResults;
  }

  Future<List<PosFoodInCartModel>> getByTableId(String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      if (model.tableId == tableId) {
        double price = 0.0;
        double addonPrice = 0.0;
        double variationPrice = 0.0;
        for (var element in model.addons!) {
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
            if (options.haveDiscount!) {
              String price = (double.parse(variationPrice.toString()) + (double.parse(options.discountPrice.toString()))).toStringAsFixed(2);
              variationPrice = double.parse(price);
            } else {
              String price = (double.parse(variationPrice.toString()) + (double.parse(options.price.toString()))).toStringAsFixed(2);
              variationPrice = double.parse(price);
            }
          }
        }

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
        rawResults.add(model);
      }
    }

    return rawResults;
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
        PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
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

  Future<void> updateProductVariationInCartLocal(String uuid, String id, int quantity, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.uuid == uuid && element.id == id && element.tableId == tableId);
    if (index != -1) {
      rawResults[index].quantity = quantity;
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<void> updateProductQuantityInCartLocal(String id, int quantity, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.id == id && element.tableId == tableId);
    if (index != -1) {
      rawResults[index].quantity = quantity;
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<void> removeFromCartLocal(String id, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.id == id && element.tableId == tableId);
    if (index != -1) {
      rawResults.removeAt(index);
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<void> removeFromCartWithUuidLocal(String uuid, String id, String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      rawResults.add(model);
    }
    int index = rawResults.indexWhere((element) => element.uuid == uuid && element.id == id && element.tableId == tableId);
    if (index != -1) {
      rawResults.removeAt(index);
      List<String> cartInString = [];
      for (var element in rawResults) {
        cartInString.add(jsonEncode(element));
      }
      await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
    }
  }

  Future<DioApiResponse> waiterInitialFoodSearch() async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterRestaurant) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.waiterInitialFoodSearch}$vendor');
  }

  Future<DioApiResponse> waiterFoodSearch(String searchQuery) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterRestaurant) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.waiterFoodSearch}$vendor/$searchQuery');
  }

  Future<DioApiResponse> addItemToCartServer(CartItemRequestModel param) async {
    return await _apiRequestService.post(ApiEndPoints.v1request.addItemToCart, body: param);
  }

  Future<void> removeFromCartWithTable(String tableId) async {
    List<String>? rawList = <String>[];
    if (await _sharedPreferencesManager.isKeyExists(SharedPreferencesKey.publicKeys.savedInCart)) {
      rawList = await _sharedPreferencesManager.getStringList(SharedPreferencesKey.publicKeys.savedInCart);
    }
    final String appLocale = await getLocale();
    List<PosFoodInCartModel> rawResults = <PosFoodInCartModel>[];
    for (var element in rawList!) {
      var items = jsonDecode(element);
      PosFoodInCartModel model = PosFoodInCartModel.fromJson(items, appLocale.toString());
      rawResults.add(model);
    }
    rawResults.removeWhere((element) => element.tableId == tableId);
    List<String> cartInString = [];
    for (var element in rawResults) {
      cartInString.add(jsonEncode(element));
    }
    await _sharedPreferencesManager.putStringList(SharedPreferencesKey.publicKeys.savedInCart, cartInString);
  }

  Future<DioApiResponse> ongoingTableOrder(String tableId) async {
    final String vendor = await _sharedPreferencesManager.getString(SharedPreferencesKey.authKeys.waiterRestaurant) ?? '';
    return await _apiRequestService.get('${ApiEndPoints.v1request.ongoingTableOrder}$vendor/$tableId');
  }
}
