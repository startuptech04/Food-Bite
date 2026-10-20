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

class ChangeDefaultPayoutMethodRequestModel {
  String? id;
  String? deliveryman;
  bool? isDefault;

  ChangeDefaultPayoutMethodRequestModel({this.id, this.deliveryman, this.isDefault});

  ChangeDefaultPayoutMethodRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryman = json['deliveryman'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deliveryman'] = deliveryman;
    data['isDefault'] = isDefault;
    return data;
  }
}
