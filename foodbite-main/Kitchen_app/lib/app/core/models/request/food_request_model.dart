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

import 'package:kitchen/app/core/models/food_variation_model.dart';

class FoodRequestModel {
  String? addons;
  List<FoodVariationModel>? variations;
  String? stockType;
  int? stockNumber;
  FoodRequestModel({this.addons, this.variations, this.stockType, this.stockNumber});

  FoodRequestModel.fromJson(Map<String, dynamic> json) {
    addons = json['addons'];
    if (json['variations'] != null) {
      variations = <FoodVariationModel>[];
      json['variations'].forEach((v) {
        variations!.add(FoodVariationModel.fromJson(v));
      });
    }
    stockType = json['stockType'];
    stockNumber = json['stockNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addons'] = addons;

    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['stockType'] = stockType;
    data['stockNumber'] = stockNumber;
    return data;
  }
}
