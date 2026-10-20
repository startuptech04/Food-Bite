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

class WalletPaymentResponseModel {
  String? user;
  String? payment;
  double? amount;
  String? paymentFrom;
  String? paymentRef;
  String? status;
  String? id;

  WalletPaymentResponseModel({this.user, this.payment, this.amount, this.paymentFrom, this.paymentRef, this.status, this.id});

  WalletPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    payment = json['payment'];
    if (json['amount'] != null && json['amount'] != '') {
      amount = double.parse(json['amount'].toString());
    } else {
      amount = 0.0;
    }
    paymentFrom = json['paymentFrom'];
    paymentRef = json['paymentRef'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['payment'] = payment;
    data['amount'] = amount;
    data['paymentFrom'] = paymentFrom;
    data['paymentRef'] = paymentRef;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
