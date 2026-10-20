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
  String? deliveryman;
  String? deliverymanPayoutMethod;
  String? withdrawalMethod;
  double? amount;

  WithdrawalRequestModel({this.deliveryman, this.deliverymanPayoutMethod, this.withdrawalMethod, this.amount});

  WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    deliveryman = json['deliveryman'];
    deliverymanPayoutMethod = json['deliverymanPayoutMethod'];
    withdrawalMethod = json['withdrawalMethod'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliveryman'] = deliveryman;
    data['deliverymanPayoutMethod'] = deliverymanPayoutMethod;
    data['withdrawalMethod'] = withdrawalMethod;
    data['amount'] = amount;
    return data;
  }
}
