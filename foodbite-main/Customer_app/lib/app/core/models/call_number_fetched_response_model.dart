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

class CallNumberFetchedResponseModel {
  bool? success;
  CallerDetailConfig? detail;

  CallNumberFetchedResponseModel({this.success, this.detail});

  CallNumberFetchedResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    detail = json['detail'] != null ? CallerDetailConfig.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    return data;
  }
}

class CallerDetailConfig {
  String? id;
  ContactInfoConfigModel? contactInfo;

  CallerDetailConfig({this.id, this.contactInfo});

  CallerDetailConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactInfo = json['contactInfo'] != null ? ContactInfoConfigModel.fromJson(json['contactInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (contactInfo != null) {
      data['contactInfo'] = contactInfo!.toJson();
    }
    return data;
  }
}

class ContactInfoConfigModel {
  String? countryCode;
  String? contactNumber;

  ContactInfoConfigModel({this.countryCode, this.contactNumber});

  ContactInfoConfigModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'].toString();
    contactNumber = json['contactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['contactNumber'] = contactNumber;
    return data;
  }
}
