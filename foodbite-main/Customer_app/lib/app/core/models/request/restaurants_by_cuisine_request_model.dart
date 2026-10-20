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

class RestaurantsByCuisineRequestModel {
  String? cuisine;
  double? latitude;
  double? longitude;
  int? limit;
  int? page;
  String? uid = '';

  RestaurantsByCuisineRequestModel({this.cuisine, this.latitude, this.longitude, this.limit, this.page, this.uid});

  RestaurantsByCuisineRequestModel.fromJson(Map<String, dynamic> json) {
    cuisine = json['cuisine'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    limit = json['limit'];
    page = json['page'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cuisine'] = cuisine;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['limit'] = limit;
    data['page'] = page;
    data['uid'] = uid;
    return data;
  }
}
