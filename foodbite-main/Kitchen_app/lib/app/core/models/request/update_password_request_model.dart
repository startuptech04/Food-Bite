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

class UpdatePasswordRequestModel {
  String? password;
  String? verificationId;
  String? token;

  UpdatePasswordRequestModel({this.password, this.verificationId, this.token});

  UpdatePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    verificationId = json['verificationId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = password;
    data['verificationId'] = verificationId;
    data['token'] = token;
    return data;
  }
}
