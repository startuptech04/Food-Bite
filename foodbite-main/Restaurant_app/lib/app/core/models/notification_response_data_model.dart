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

class NotificationResponseDataModel {
  String? type;
  String? value;
  String? extra;

  NotificationResponseDataModel({this.type, this.value, this.extra});

  NotificationResponseDataModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    extra = json['extra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    data['extra'] = extra;
    return data;
  }
}
