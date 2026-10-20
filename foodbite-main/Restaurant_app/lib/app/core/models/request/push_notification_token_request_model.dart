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

class PushNotificationTokenRequestModel {
  String? user;
  String? token;
  String? deviceId;
  String? deviceType;

  PushNotificationTokenRequestModel({this.user, this.token, this.deviceId, this.deviceType});

  PushNotificationTokenRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    token = json['token'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['token'] = token;
    data['deviceId'] = deviceId;
    data['deviceType'] = deviceType;
    return data;
  }
}
