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

class CreateRefundRequestModel {
  String? reason;
  String? user;
  String? orders;
  String? restaurant;
  String? payment;

  CreateRefundRequestModel({this.reason, this.user, this.orders, this.restaurant, this.payment});

  CreateRefundRequestModel.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    user = json['user'];
    orders = json['orders'];
    restaurant = json['restaurant'];
    payment = json['payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = reason;
    data['user'] = user;
    data['orders'] = orders;
    data['restaurant'] = restaurant;
    data['payment'] = payment;
    return data;
  }
}
