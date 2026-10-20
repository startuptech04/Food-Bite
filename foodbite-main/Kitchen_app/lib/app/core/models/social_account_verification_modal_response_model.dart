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

class SocialAccountVerificationModalResponseModel {
  bool? success;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? mobile;

  SocialAccountVerificationModalResponseModel({this.success, this.firstName, this.lastName, this.countryCode, this.mobile});

  SocialAccountVerificationModalResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    return data;
  }
}
