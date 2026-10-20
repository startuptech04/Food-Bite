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

class RepayPendingOrderRequestModel {
  String? orderId;
  String? userId;
  String? payMethod;
  String? newPayMethod;

  RepayPendingOrderRequestModel({this.orderId, this.userId, this.payMethod, this.newPayMethod});

  RepayPendingOrderRequestModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userId = json['userId'];
    payMethod = json['payMethod'];
    newPayMethod = json['newPayMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['userId'] = userId;
    data['payMethod'] = payMethod;
    data['newPayMethod'] = newPayMethod;
    return data;
  }
}
