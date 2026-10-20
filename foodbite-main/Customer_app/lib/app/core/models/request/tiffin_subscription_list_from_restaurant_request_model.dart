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

class TiffinSubscriptionFromListRestaurantRequestModel {
  String? restaurant;
  int? limit;
  int? page;

  TiffinSubscriptionFromListRestaurantRequestModel({this.restaurant, this.limit, this.page});

  TiffinSubscriptionFromListRestaurantRequestModel.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    limit = json['limit'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant'] = restaurant;
    data['limit'] = limit;
    data['page'] = page;
    return data;
  }
}
