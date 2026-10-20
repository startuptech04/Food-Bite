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

class UpdatePasswordFirebaseRequestModel {
  String? password;
  String? token;
  String? qtoken;

  UpdatePasswordFirebaseRequestModel({this.password, this.token, this.qtoken});

  UpdatePasswordFirebaseRequestModel.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    token = json['token'];
    qtoken = json['qtoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = password;
    data['token'] = token;
    data['qtoken'] = qtoken;
    return data;
  }
}
