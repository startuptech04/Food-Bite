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

class ReportEmergencyFormRequestModel {
  String? type;
  String? userName;
  String? userCountryCode;
  String? userContact;
  String? userEmail;
  String? shortDescription;

  ReportEmergencyFormRequestModel({this.type, this.userName, this.userCountryCode, this.userContact, this.userEmail, this.shortDescription});

  ReportEmergencyFormRequestModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    userName = json['userName'];
    userCountryCode = json['userCountryCode'];
    userContact = json['userContact'];
    userEmail = json['userEmail'];
    shortDescription = json['shortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['userName'] = userName;
    data['userCountryCode'] = userCountryCode;
    data['userContact'] = userContact;
    data['userEmail'] = userEmail;
    data['shortDescription'] = shortDescription;
    return data;
  }
}
