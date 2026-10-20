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

import 'package:vendor/app/core/models/translations/custom_category_form_translation.dart';

class CustomCategoryRequestModel {
  String? name;
  String? image;
  String? restaurant;
  bool? status;
  List<CustomCategoryFormTranslations>? translations;
  CustomCategoryRequestModel({this.name, this.image, this.restaurant, this.status = true, this.translations});

  CustomCategoryRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    restaurant = json['restaurant'];
    status = json['status'];
    if (json['translations'] != null) {
      translations = <CustomCategoryFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CustomCategoryFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['restaurant'] = restaurant;
    data['status'] = status;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
