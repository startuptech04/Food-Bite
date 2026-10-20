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

class RestaurantInfoRequestModel {
  String? slug;
  double? latitude;
  double? longitude;
  String? uid;

  RestaurantInfoRequestModel({this.slug, this.latitude, this.longitude, this.uid});

  RestaurantInfoRequestModel.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slug'] = slug;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['uid'] = uid;
    return data;
  }
}
