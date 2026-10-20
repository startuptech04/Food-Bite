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

import 'package:vendor/app/core/models/translations/custom_sub_category_form_translation.dart';

class CustomSubCategoryRequestModel {
  String? name;
  String? category;
  String? restaurant;
  bool? status;
  List<CustomSubCategoryFormTranslations>? translations;
  CustomSubCategoryRequestModel({this.name, this.category, this.restaurant, this.status = true, this.translations});

  CustomSubCategoryRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    restaurant = json['restaurant'];
    category = json['category'];
    status = json['status'];
    if (json['translations'] != null) {
      translations = <CustomSubCategoryFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CustomSubCategoryFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['restaurant'] = restaurant;
    data['category'] = category;
    data['status'] = status;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
