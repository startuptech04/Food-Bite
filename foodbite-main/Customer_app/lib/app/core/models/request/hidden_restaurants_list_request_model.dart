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

class HiddenRestaurantListRequestModel {
  String? uid;
  double? latitude;
  double? longitude;

  HiddenRestaurantListRequestModel({this.uid, this.latitude, this.longitude});

  HiddenRestaurantListRequestModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
