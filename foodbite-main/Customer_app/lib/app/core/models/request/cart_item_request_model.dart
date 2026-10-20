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

class CartItemRequestModel {
  String? user;
  String? trackingId;
  String? uuid;
  String? addons;
  String? food;
  String? restaurant;
  int? quantity;
  List<ServerSavedVariationOptionModel>? variations;
  String? campaignId;
  String? campaignType;
  String? cookingInstruction;

  CartItemRequestModel({this.user, this.trackingId, this.uuid, this.addons, this.food, this.restaurant, this.quantity, this.variations, this.campaignId, this.campaignType, this.cookingInstruction});

  CartItemRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    trackingId = json['trackingId'];
    uuid = json['uuid'];
    addons = json['addons'];
    food = json['food'];
    restaurant = json['restaurant'];
    quantity = json['quantity'];
    if (json['variations'] != null) {
      variations = <ServerSavedVariationOptionModel>[];
      json['variations'].forEach((v) {
        variations!.add(ServerSavedVariationOptionModel.fromJson(v));
      });
    } else {
      variations = [];
    }
    campaignId = json['campaignId'];
    campaignType = json['campaignType'];
    if (json['cookingInstruction'] != null && json['cookingInstruction'] != '') {
      cookingInstruction = json['cookingInstruction'];
    } else {
      cookingInstruction = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['trackingId'] = trackingId;
    data['uuid'] = uuid;
    data['addons'] = addons;
    data['food'] = food;
    data['restaurant'] = restaurant;
    data['quantity'] = quantity;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['campaignId'] = campaignId;
    data['campaignType'] = campaignType;
    data['cookingInstruction'] = cookingInstruction;
    return data;
  }
}

class ServerSavedVariationOptionModel {
  String? variation;
  List<String>? selected;

  ServerSavedVariationOptionModel({this.variation, this.selected});

  ServerSavedVariationOptionModel.fromJson(Map<String, dynamic> json) {
    variation = json['variation'];
    selected = json['selected'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation'] = variation;
    data['selected'] = selected;
    return data;
  }
}
