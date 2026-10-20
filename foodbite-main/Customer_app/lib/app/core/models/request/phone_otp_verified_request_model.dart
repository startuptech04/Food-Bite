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

class PhoneOTPVerifiedLoginRequestModel {
  String? id;
  bool? remember;
  String? locale;
  String? userAgent;

  PhoneOTPVerifiedLoginRequestModel({this.id, this.remember, this.locale, this.userAgent});

  PhoneOTPVerifiedLoginRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    remember = json['remember'];
    locale = json['locale'];
    userAgent = json['userAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['remember'] = remember;
    data['locale'] = locale;
    data['userAgent'] = userAgent;
    return data;
  }
}
