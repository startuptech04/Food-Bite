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

class TiffinSubscriptionFoodConfigRequestModel {
  String? id;
  String? addon;
  List<SelectedVariationConfigModel>? variations;

  TiffinSubscriptionFoodConfigRequestModel({this.id, this.addon, this.variations});

  TiffinSubscriptionFoodConfigRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addon = json['addon'];
    if (json['variations'] != null) {
      variations = <SelectedVariationConfigModel>[];
      json['variations'].forEach((v) {
        variations!.add(SelectedVariationConfigModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['addon'] = addon;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedVariationConfigModel {
  String? variation;
  List<String>? selected;

  SelectedVariationConfigModel({this.variation, this.selected});

  SelectedVariationConfigModel.fromJson(Map<String, dynamic> json) {
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
