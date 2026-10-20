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

class RenewSubscriptionPaymentResponseModel {
  bool? success;
  String? payLink;

  RenewSubscriptionPaymentResponseModel({this.success, this.payLink});

  RenewSubscriptionPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    payLink = json['payLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['payLink'] = payLink;
    return data;
  }
}
