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

class RegisterGoogleUserAccountRequestModel {
  String? firstName;
  String? lastName;
  String? countryCode;
  String? mobile;
  String? idToken;
  bool? remember;
  String? userAgent;
  String? locale;

  RegisterGoogleUserAccountRequestModel({this.firstName, this.lastName, this.countryCode, this.mobile, this.idToken, this.remember, this.userAgent, this.locale});

  RegisterGoogleUserAccountRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    idToken = json['idToken'];
    remember = json['remember'];
    userAgent = json['userAgent'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['idToken'] = idToken;
    data['remember'] = remember;
    data['userAgent'] = userAgent;
    data['locale'] = locale;
    return data;
  }
}
