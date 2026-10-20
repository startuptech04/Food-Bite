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

class DiningBookingCallCustomerResponseModel {
  Details? details;
  bool? success;

  DiningBookingCallCustomerResponseModel({this.details, this.success});

  DiningBookingCallCustomerResponseModel.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class Details {
  String? userCountryCode;
  String? userContact;
  String? id;

  Details({this.userCountryCode, this.userContact, this.id});

  Details.fromJson(Map<String, dynamic> json) {
    userCountryCode = json['userCountryCode'].toString();
    userContact = json['userContact'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userCountryCode'] = userCountryCode;
    data['userContact'] = userContact;
    data['id'] = id;
    return data;
  }
}
