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

class FoodCampaignRequestModel {
  String? campaignId;
  String? uid;

  FoodCampaignRequestModel({this.campaignId, this.uid});

  FoodCampaignRequestModel.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['campaignId'] = campaignId;
    data['uid'] = uid;
    return data;
  }
}
