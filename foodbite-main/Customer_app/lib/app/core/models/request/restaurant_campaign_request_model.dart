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

class RestaurantCampaignRequestModel {
  String? campaignId;
  double? latitude;
  double? longitude;
  String? uid;

  RestaurantCampaignRequestModel({this.campaignId, this.latitude, this.longitude, this.uid});

  RestaurantCampaignRequestModel.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['campaignId'] = campaignId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['uid'] = uid;
    return data;
  }
}
