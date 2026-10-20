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

class UpdateCartFoodQuantityRequestModel {
  String? trackingId;
  String? id;
  int? quantity;

  UpdateCartFoodQuantityRequestModel({this.trackingId, this.id, this.quantity});

  UpdateCartFoodQuantityRequestModel.fromJson(Map<String, dynamic> json) {
    trackingId = json['trackingId'];
    id = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trackingId'] = trackingId;
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}
