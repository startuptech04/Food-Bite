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

class SingleFoodInfoRequestModel {
  String? foodId;
  String? uid = '';

  SingleFoodInfoRequestModel({this.foodId, this.uid});

  SingleFoodInfoRequestModel.fromJson(Map<String, dynamic> json) {
    foodId = json['foodId'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foodId'] = foodId;
    data['uid'] = uid;
    return data;
  }
}
