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

class SaveFavouriteRequestModel {
  String? user;
  String? type;
  String? restaurant = '';
  String? food = '';
  SaveFavouriteRequestModel({this.user, this.type, this.restaurant, this.food});

  SaveFavouriteRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    type = json['type'];
    restaurant = json['restaurant'];
    food = json['food'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['type'] = type;
    data['restaurant'] = restaurant;
    data['food'] = food;
    return data;
  }
}
