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

class RedeemCouponRequestModel {
  String? user;
  String? coupon;
  String? tracking;
  String? restaurant;

  RedeemCouponRequestModel({this.user, this.coupon, this.tracking, this.restaurant});

  RedeemCouponRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    coupon = json['coupon'];
    tracking = json['tracking'];
    restaurant = json['restaurant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['coupon'] = coupon;
    data['tracking'] = tracking;
    data['restaurant'] = restaurant;
    return data;
  }
}
