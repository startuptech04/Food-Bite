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

class TiffinSubscriptionRequestOffDayRequestModel {
  String? purchaseId;
  String? offDayDate;

  TiffinSubscriptionRequestOffDayRequestModel({this.purchaseId, this.offDayDate});

  TiffinSubscriptionRequestOffDayRequestModel.fromJson(Map<String, dynamic> json) {
    purchaseId = json['purchaseId'];
    offDayDate = json['offDayDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purchaseId'] = purchaseId;
    data['offDayDate'] = offDayDate;
    return data;
  }
}
