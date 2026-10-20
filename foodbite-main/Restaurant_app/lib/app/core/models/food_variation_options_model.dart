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

class FoodVariationOptionModel {
  String? name;
  String? price;
  String? stock;

  FoodVariationOptionModel({this.name, this.price, this.stock});

  FoodVariationOptionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    if (json['stock'] != null && json['stock'] != '') {
      stock = json['stock'];
    } else {
      stock = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['stock'] = stock;
    return data;
  }
}
