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

class FirebaseSMSOTPVerificationResponseModel {
  bool? action;
  bool? status;
  String? token;

  FirebaseSMSOTPVerificationResponseModel({this.action, this.status, this.token});

  FirebaseSMSOTPVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['status'] = status;
    data['token'] = token;
    return data;
  }
}
