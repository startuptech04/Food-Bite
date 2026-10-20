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

import 'package:kitchen/app/core/models/food_variation_options_model.dart';

class FoodVariationModel {
  String? isRequired;
  String? title;
  String? type;
  String? min;
  String? max;
  List<FoodVariationOptionModel>? options;

  FoodVariationModel({this.isRequired, this.title, this.type, this.min, this.max, this.options});

  FoodVariationModel.fromJson(Map<String, dynamic> json) {
    isRequired = json['isRequired'];
    title = json['title'];
    type = json['type'];
    min = json['min'];
    max = json['max'];
    if (json['options'] != null) {
      options = <FoodVariationOptionModel>[];
      json['options'].forEach((v) {
        options!.add(FoodVariationOptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequired'] = isRequired;
    data['title'] = title;
    data['type'] = type;
    data['min'] = min;
    data['max'] = max;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
