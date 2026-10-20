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

class DiningBookingRefundRequestModel {
  String? user;
  String? booking;
  String? reason;
  String? restaurant;
  String? payment;

  DiningBookingRefundRequestModel({this.user, this.booking, this.reason, this.restaurant, this.payment});

  DiningBookingRefundRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    booking = json['booking'];
    reason = json['reason'];
    restaurant = json['restaurant'];
    payment = json['payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['booking'] = booking;
    data['reason'] = reason;
    data['restaurant'] = restaurant;
    data['payment'] = payment;
    return data;
  }
}
