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

import 'package:vendor/app/core/models/translations/addons_form_translation.dart';

class AddonsRequestModel {
  String? name;
  String? price;
  String? restaurant;
  String? stockType;
  int? stockNumber;
  bool? status;
  bool? inStock;
  List<AddonsFormTranslations>? translations;

  AddonsRequestModel({this.name, this.price, this.restaurant, this.stockType, this.stockNumber, this.status = true, this.inStock = true, this.translations});

  AddonsRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    restaurant = json['restaurant'];
    stockType = json['stockType'];
    stockNumber = json['stockNumber'];
    status = json['status'];
    inStock = json['inStock'];
    if (json['translations'] != null) {
      translations = <AddonsFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(AddonsFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['restaurant'] = restaurant;
    data['stockType'] = stockType;
    data['stockNumber'] = stockNumber;
    data['status'] = status;
    data['inStock'] = inStock;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
