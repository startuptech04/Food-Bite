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

class CreateOrUpdateRestaurantTableRequestModel {
  String? restaurant;
  String? tableNumber;
  String? capacity;

  CreateOrUpdateRestaurantTableRequestModel({this.restaurant, this.tableNumber, this.capacity});

  CreateOrUpdateRestaurantTableRequestModel.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    tableNumber = json['tableNumber'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant'] = restaurant;
    data['tableNumber'] = tableNumber;
    data['capacity'] = capacity;
    return data;
  }
}
