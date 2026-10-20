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

class TiffinSubscriptionFoodModalResponseModel {
  bool? action;
  List<String>? id;
  List<String>? name;

  TiffinSubscriptionFoodModalResponseModel({this.action, this.id, this.name});

  TiffinSubscriptionFoodModalResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    id = json['id'].cast<String>();
    name = json['name'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
