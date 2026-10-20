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

class WithdrawalRequestModel {
  String? restaurant;
  String? restaurantPayoutMethod;
  String? withdrawalMethod;
  double? amount;

  WithdrawalRequestModel({this.restaurant, this.restaurantPayoutMethod, this.withdrawalMethod, this.amount});

  WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    restaurantPayoutMethod = json['restaurantPayoutMethod'];
    withdrawalMethod = json['withdrawalMethod'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant'] = restaurant;
    data['restaurantPayoutMethod'] = restaurantPayoutMethod;
    data['withdrawalMethod'] = withdrawalMethod;
    data['amount'] = amount;
    return data;
  }
}
