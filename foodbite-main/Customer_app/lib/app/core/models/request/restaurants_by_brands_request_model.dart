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

class RestaurantsByBrandsRequestModel {
  String? outlet;
  double? latitude;
  double? longitude;
  String? uid = '';

  RestaurantsByBrandsRequestModel({this.outlet, this.latitude, this.longitude, this.uid});

  RestaurantsByBrandsRequestModel.fromJson(Map<String, dynamic> json) {
    outlet = json['outlet'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['outlet'] = outlet;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['uid'] = uid;
    return data;
  }
}
