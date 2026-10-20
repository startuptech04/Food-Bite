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
  String? tableId;
  int? tableNumber;
  String? restaurant;
  String? waiter;
  List<CartItemServerObjectModel>? cartItem;

  CartItemRequestModel({this.tableId, this.tableNumber, this.restaurant, this.waiter, this.cartItem});

  CartItemRequestModel.fromJson(Map<String, dynamic> json) {
    tableId = json['tableId'];
    tableNumber = json['tableNumber'];
    restaurant = json['restaurant'];
    waiter = json['waiter'];
    if (json['cartItem'] != null) {
      cartItem = <CartItemServerObjectModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(CartItemServerObjectModel.fromJson(v));
      });
    } else {
      cartItem = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tableId'] = tableId;
    data['tableNumber'] = tableNumber;
    data['restaurant'] = restaurant;
    data['waiter'] = waiter;
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemServerObjectModel {
  String? uuid;
  String? addons;
  String? food;
  int? quantity;
  List<ServerSavedVariationOptionModel>? variations;
  String? instruction;

  CartItemServerObjectModel({this.uuid, this.addons, this.food, this.quantity, this.variations, this.instruction});

  CartItemServerObjectModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    addons = json['addons'];
    food = json['food'];
    quantity = json['quantity'];
    if (json['variations'] != null) {
      variations = <ServerSavedVariationOptionModel>[];
      json['variations'].forEach((v) {
        variations!.add(ServerSavedVariationOptionModel.fromJson(v));
      });
    } else {
      variations = [];
    }
    if (json['instruction'] != null && json['instruction'] != '') {
      instruction = json['instruction'];
    } else {
      instruction = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['addons'] = addons;
    data['food'] = food;
    data['quantity'] = quantity;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['instruction'] = instruction;
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
