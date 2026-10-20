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

class NotificationCountResponseModel {
  int? count;
  bool? success;

  NotificationCountResponseModel({this.count, this.success});

  NotificationCountResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['count'] != null && json['count'] != '') {
      count = int.parse(json['count'].toString());
    } else {
      count = 0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['success'] = success;
    return data;
  }
}
