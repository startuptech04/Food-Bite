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

class MakeWalletPaymentRequestModel {
  String? user;
  String? payment;
  double? amount;
  String? from;
  String? ref;

  MakeWalletPaymentRequestModel({this.user, this.payment, this.amount, this.from, this.ref});

  MakeWalletPaymentRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    payment = json['payment'];
    amount = json['amount'];
    from = json['from'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['payment'] = payment;
    data['amount'] = amount;
    data['from'] = from;
    data['ref'] = ref;
    return data;
  }
}
