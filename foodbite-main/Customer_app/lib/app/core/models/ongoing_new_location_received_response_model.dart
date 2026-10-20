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

class OngoingNewLocationReceivedLocationResponseModel {
  String? driverId;
  double? latitude;
  double? longitude;

  OngoingNewLocationReceivedLocationResponseModel({this.driverId, this.latitude, this.longitude});

  OngoingNewLocationReceivedLocationResponseModel.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    if (json['latitude'] != null && json['latitude'] != '') {
      latitude = double.parse(json['latitude'].toString());
    } else {
      latitude = 0.0;
    }
    if (json['longitude'] != null && json['longitude'] != '') {
      longitude = double.parse(json['longitude'].toString());
    } else {
      longitude = 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverId'] = driverId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
