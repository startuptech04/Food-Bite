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

class CheckRestaurantRegisterStatusRequestModel {
  String? email;
  String? countryCode;
  String? mobile;
  CheckRestaurantRegisterStatusRequestModel({this.email, this.countryCode, this.mobile});

  CheckRestaurantRegisterStatusRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    return data;
  }
}
