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

class PosRestaurantModalCategoryModel {
  String? name;
  String? id;
  int? count;
  PosRestaurantModalCategoryModel({this.name, this.id, this.count});

  PosRestaurantModalCategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['count'] = count;
    return data;
  }
}
