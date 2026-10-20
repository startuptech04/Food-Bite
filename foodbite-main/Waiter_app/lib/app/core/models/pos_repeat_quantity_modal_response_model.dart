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

class PosRepeatQuantityModalResponseModel {
  String? action;
  Data? data;

  PosRepeatQuantityModalResponseModel({this.action, this.data});

  PosRepeatQuantityModalResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  List<FoodUuidAndQuantity>? list;

  Data({this.id, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['list'] != null) {
      list = <FoodUuidAndQuantity>[];
      json['list'].forEach((v) {
        list!.add(FoodUuidAndQuantity.fromJson(v));
      });
    } else {
      list = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodUuidAndQuantity {
  String? uuid;
  int? quantity;

  FoodUuidAndQuantity({this.uuid, this.quantity});

  FoodUuidAndQuantity.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['quantity'] = quantity;
    return data;
  }
}
