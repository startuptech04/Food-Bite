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

import 'package:vendor/app/core/models/food_variation_model.dart';
import 'package:vendor/app/core/models/translations/food_form_translation.dart';

class FoodRequestModel {
  String? name;
  String? shortDescription;
  String? image;
  String? restaurant;
  bool? ownCategory;
  String? category;
  String? subCategory;
  String? customCategory;
  String? customSubCategory;
  String? foodType;
  String? addons;
  String? startTime;
  String? endTime;
  double? price;
  String? discountType;
  double? discount;
  List<String>? tags;
  List<FoodFormTranslations>? translations;
  int? purchaseLimit;
  List<FoodVariationModel>? variations;
  bool? taxationEnable;
  String? foodTax;
  String? stockType;
  int? stockNumber;
  FoodRequestModel({
    this.name,
    this.shortDescription,
    this.image,
    this.restaurant,
    this.ownCategory,
    this.category,
    this.subCategory,
    this.customCategory,
    this.customSubCategory,
    this.foodType,
    this.addons,
    this.startTime,
    this.endTime,
    this.price,
    this.discountType,
    this.discount,
    this.tags,
    this.translations,
    this.purchaseLimit,
    this.variations,
    this.taxationEnable,
    this.foodTax,
    this.stockType,
    this.stockNumber,
  });

  FoodRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortDescription = json['shortDescription'];
    image = json['image'];
    restaurant = json['restaurant'];
    ownCategory = json['ownCategory'];
    category = json['category'];
    subCategory = json['subCategory'];
    customCategory = json['customCategory'];
    customSubCategory = json['customSubCategory'];
    foodType = json['foodType'];
    addons = json['addons'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    price = double.parse(json['price'].toString());
    discountType = json['discountType'];
    discount = double.parse(json['discount'].toString());
    tags = json['tags'].cast<String>();
    if (json['translations'] != null) {
      translations = <FoodFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(FoodFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
    purchaseLimit = int.parse(json['purchaseLimit'].toString());
    if (json['variations'] != null) {
      variations = <FoodVariationModel>[];
      json['variations'].forEach((v) {
        variations!.add(FoodVariationModel.fromJson(v));
      });
    }
    taxationEnable = json['taxationEnable'];
    foodTax = json['foodTax'];
    stockType = json['stockType'];
    stockNumber = json['stockNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['image'] = image;
    data['restaurant'] = restaurant;
    data['ownCategory'] = ownCategory;
    data['category'] = category;
    data['subCategory'] = subCategory;
    data['customCategory'] = customCategory;
    data['customSubCategory'] = customSubCategory;
    data['foodType'] = foodType;
    data['addons'] = addons;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['price'] = price;
    data['discountType'] = discountType;
    data['discount'] = discount;
    data['tags'] = tags;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['purchaseLimit'] = purchaseLimit;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['taxationEnable'] = taxationEnable;
    data['foodTax'] = foodTax;
    data['stockType'] = stockType;
    data['stockNumber'] = stockNumber;
    return data;
  }
}
