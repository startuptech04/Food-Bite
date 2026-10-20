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

class UpdateCartFoodVariationQuantityRequestModel {
  String? trackingId;
  String? uuid;
  String? id;
  int? quantity;

  UpdateCartFoodVariationQuantityRequestModel({this.trackingId, this.uuid, this.id, this.quantity});

  UpdateCartFoodVariationQuantityRequestModel.fromJson(Map<String, dynamic> json) {
    trackingId = json['trackingId'];
    uuid = json['uuid'];
    id = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trackingId'] = trackingId;
    data['uuid'] = uuid;
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}
