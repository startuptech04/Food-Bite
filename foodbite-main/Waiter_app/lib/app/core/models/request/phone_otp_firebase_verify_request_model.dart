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

class PhoneOTPFirebaseVerifyRequestModel {
  String? countryCode;
  int? mobileNumber;
  String? token;
  String? locale;
  bool? remember;
  String? userAgent;

  PhoneOTPFirebaseVerifyRequestModel({this.countryCode, this.mobileNumber, this.token, this.locale, this.remember, this.userAgent});

  PhoneOTPFirebaseVerifyRequestModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    mobileNumber = json['mobileNumber'];
    token = json['token'];
    locale = json['locale'];
    remember = json['remember'];
    userAgent = json['userAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['mobileNumber'] = mobileNumber;
    data['token'] = token;
    data['locale'] = locale;
    data['remember'] = remember;
    data['userAgent'] = userAgent;
    return data;
  }
}
