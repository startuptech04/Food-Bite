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

class RepeatQuantityListModal {
  String? id;
  List<FoodUuidAndQuantity>? list;

  RepeatQuantityListModal({this.id, this.list});

  RepeatQuantityListModal.fromJson(Map<String, dynamic> json) {
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
