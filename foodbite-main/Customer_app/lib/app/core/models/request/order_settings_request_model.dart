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

class OrderSettingsRequestModel {
  String? userId;
  String? restaurant;
  String? deliveryAddressId;
  double? userLatitude;
  double? userLongitude;
  String? trackingId;

  OrderSettingsRequestModel({this.userId, this.restaurant, this.deliveryAddressId, this.userLatitude, this.userLongitude, this.trackingId});

  OrderSettingsRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    restaurant = json['restaurant'];
    deliveryAddressId = json['deliveryAddressId'];
    userLatitude = json['userLatitude'];
    userLongitude = json['userLongitude'];
    trackingId = json['trackingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['restaurant'] = restaurant;
    data['deliveryAddressId'] = deliveryAddressId;
    data['userLatitude'] = userLatitude;
    data['userLongitude'] = userLongitude;
    data['trackingId'] = trackingId;
    return data;
  }
}
