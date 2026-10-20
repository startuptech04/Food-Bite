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

class WebSMSOTPVerificationResponseModel {
  bool? action;
  bool? success;
  String? dummyOTP;
  String? id;

  WebSMSOTPVerificationResponseModel({this.action, this.success, this.dummyOTP, this.id});

  WebSMSOTPVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    success = json['success'];
    dummyOTP = json['dummyOTP'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['success'] = success;
    data['dummyOTP'] = dummyOTP;
    data['id'] = id;
    return data;
  }
}
