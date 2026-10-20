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

class RedeemLoyaltyPointRequestModel {
  String? user;
  String? ids;

  RedeemLoyaltyPointRequestModel({this.user, this.ids});

  RedeemLoyaltyPointRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    ids = json['ids'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['ids'] = ids;
    return data;
  }
}
