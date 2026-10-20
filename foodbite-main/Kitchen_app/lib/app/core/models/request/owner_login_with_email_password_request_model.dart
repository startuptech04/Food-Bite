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

class OwnerLoginWithEmailAndPasswordRequestModel {
  String? email;
  String? password;
  bool? remember;
  String? userAgent;
  String? locale;

  OwnerLoginWithEmailAndPasswordRequestModel({this.email, this.password, this.remember, this.userAgent, this.locale});

  OwnerLoginWithEmailAndPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    remember = json['remember'];
    userAgent = json['userAgent'];
    if (json['locale'] != null && json['locale'] != '') {
      locale = json['locale'];
    } else {
      locale = 'en';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['remember'] = remember;
    data['userAgent'] = userAgent;
    data['locale'] = locale;
    return data;
  }
}
