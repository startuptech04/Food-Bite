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

class RejectOrderRequestModel {
  String? id;
  String? reason;
  String? restaurant;

  RejectOrderRequestModel({this.id, this.reason, this.restaurant});

  RejectOrderRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    restaurant = json['restaurant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['restaurant'] = restaurant;
    return data;
  }
}
