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

class RestaurantAccountDeleteRequestModel {
  String? reason;
  String? user;
  String? restaurant;

  RestaurantAccountDeleteRequestModel({this.reason, this.user, this.restaurant});

  RestaurantAccountDeleteRequestModel.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    user = json['user'];
    restaurant = json['restaurant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = reason;
    data['user'] = user;
    data['restaurant'] = restaurant;
    return data;
  }
}
