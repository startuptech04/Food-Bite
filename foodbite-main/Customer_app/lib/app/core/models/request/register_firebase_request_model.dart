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

class UserFirebaseRegisterRequest {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? mobile;
  String? locale;
  String? referralCode;
  bool? isEmailVerified;
  bool? isMobileVerified;
  String? userAgent;
  String? token;

  UserFirebaseRegisterRequest({this.email, this.password, this.firstName, this.lastName, this.countryCode, this.mobile, this.locale, this.referralCode, this.isEmailVerified, this.isMobileVerified, this.userAgent, this.token});

  UserFirebaseRegisterRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    locale = json['locale'];
    referralCode = json['referralCode'];
    isEmailVerified = json['isEmailVerified'];
    isMobileVerified = json['isMobileVerified'];
    userAgent = json['userAgent'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['locale'] = locale;
    data['referralCode'] = referralCode;
    data['isEmailVerified'] = isEmailVerified;
    data['isMobileVerified'] = isMobileVerified;
    data['userAgent'] = userAgent;
    data['token'] = token;
    return data;
  }
}
