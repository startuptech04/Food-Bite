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

class OrderProofRequestModel {
  String? orderId;
  String? pickup;
  String? dropup;
  String? type;

  OrderProofRequestModel({this.orderId, this.pickup, this.dropup, this.type});

  OrderProofRequestModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    pickup = json['pickup'];
    dropup = json['dropup'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['pickup'] = pickup;
    data['dropup'] = dropup;
    data['type'] = type;
    return data;
  }
}
