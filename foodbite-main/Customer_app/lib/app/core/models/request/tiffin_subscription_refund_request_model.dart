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

class TiffinSubscriptionRefundRequestModel {
  String? user;
  String? purchaseId;
  String? reason;
  String? subscriptionPackage;
  String? restaurant;
  String? payment;

  TiffinSubscriptionRefundRequestModel({this.user, this.purchaseId, this.reason, this.subscriptionPackage, this.restaurant, this.payment});

  TiffinSubscriptionRefundRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    purchaseId = json['purchaseId'];
    reason = json['reason'];
    subscriptionPackage = json['subscriptionPackage'];
    restaurant = json['restaurant'];
    payment = json['payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['purchaseId'] = purchaseId;
    data['reason'] = reason;
    data['subscriptionPackage'] = subscriptionPackage;
    data['restaurant'] = restaurant;
    data['payment'] = payment;
    return data;
  }
}
