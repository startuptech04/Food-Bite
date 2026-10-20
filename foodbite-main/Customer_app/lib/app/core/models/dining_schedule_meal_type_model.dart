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

class DiningScheduleMealTypeModel {
  int? mealIndex;
  String? lable;
  String? value;
  int? totalOffers = 0;
  List<String>? slots;

  DiningScheduleMealTypeModel({this.mealIndex, this.lable, this.value, this.totalOffers, this.slots});

  DiningScheduleMealTypeModel.fromJson(Map<String, dynamic> json) {
    mealIndex = json['mealIndex'];
    lable = json['lable'];
    value = json['value'];
    totalOffers = json['totalOffers'];
    slots = json['slots'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mealIndex'] = mealIndex;
    data['lable'] = lable;
    data['value'] = value;
    data['totalOffers'] = totalOffers;
    data['slots'] = slots;
    return data;
  }
}
