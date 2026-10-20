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

class WaiterInfoResponseModel {
  WaiterInfoConfigModel? info;
  bool? success;

  WaiterInfoResponseModel({this.info, this.success});

  WaiterInfoResponseModel.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? WaiterInfoConfigModel.fromJson(json['info']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class WaiterInfoConfigModel {
  String? firstName;
  String? lastName;
  String? email;
  bool? isEmailVerified;
  String? image;
  String? countryCode;
  String? mobile;
  bool? isMobileVerified;
  String? gender;
  String? id;

  WaiterInfoConfigModel({this.firstName, this.lastName, this.email, this.isEmailVerified, this.image, this.countryCode, this.mobile, this.isMobileVerified, this.gender, this.id});

  WaiterInfoConfigModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    mobile = json['mobile'];
    isMobileVerified = json['isMobileVerified'];
    gender = json['gender'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['isEmailVerified'] = isEmailVerified;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['isMobileVerified'] = isMobileVerified;
    data['gender'] = gender;
    data['id'] = id;
    return data;
  }
}
