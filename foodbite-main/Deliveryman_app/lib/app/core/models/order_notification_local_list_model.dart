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

class OrderNotificationLocalListModel {
  String? notificationId;
  String? createdAt;
  String? extra;
  String? status;

  OrderNotificationLocalListModel({this.notificationId, this.createdAt, this.extra, this.status});

  OrderNotificationLocalListModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    createdAt = json['createdAt'];
    extra = json['extra'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_id'] = notificationId;
    data['createdAt'] = createdAt;
    data['extra'] = extra;
    data['status'] = status;
    return data;
  }
}
