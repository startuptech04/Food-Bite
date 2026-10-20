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

import 'package:vendor/app/core/models/translations/food_taxation_form_translation.dart';

class FoodTaxationDialogRequestModel {
  String? restaurant;
  String? taxName;
  double? taxAmount;
  List<FoodTaxationFormTranslations>? translation;

  FoodTaxationDialogRequestModel({this.restaurant, this.taxName, this.taxAmount, this.translation});

  FoodTaxationDialogRequestModel.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    taxName = json['taxName'];
    taxAmount = json['taxAmount'];
    if (json['translation'] != null) {
      translation = <FoodTaxationFormTranslations>[];
      json['translation'].forEach((v) {
        translation!.add(FoodTaxationFormTranslations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant'] = restaurant;
    data['taxName'] = taxName;
    data['taxAmount'] = taxAmount;
    if (translation != null) {
      data['translation'] = translation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
