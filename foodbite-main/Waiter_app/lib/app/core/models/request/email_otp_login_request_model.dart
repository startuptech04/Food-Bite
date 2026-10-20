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

class LoginWithEmailOtpRequestModel {
  String? email;
  bool? remember;
  String? userAgent;
  String? locale;
  String? verificationId;
  String? verificationCode;

  LoginWithEmailOtpRequestModel({this.email, this.remember, this.userAgent, this.locale, this.verificationId, this.verificationCode});

  LoginWithEmailOtpRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    remember = json['remember'];
    userAgent = json['userAgent'];
    locale = json['locale'];
    verificationId = json['verificationId'];
    verificationCode = json['verificationCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['remember'] = remember;
    data['userAgent'] = userAgent;
    data['locale'] = locale;
    data['verificationId'] = verificationId;
    data['verificationCode'] = verificationCode;
    return data;
  }
}
