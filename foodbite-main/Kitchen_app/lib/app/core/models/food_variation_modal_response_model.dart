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

class FoodVariationModalResponseModel {
  bool? action;
  FoodVariationModel? data;

  FoodVariationModalResponseModel({this.action, this.data});

  FoodVariationModalResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    data = json['data'] != null ? FoodVariationModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
