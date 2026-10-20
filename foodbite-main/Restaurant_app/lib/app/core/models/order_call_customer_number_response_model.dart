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

class OrderCallCustomerNumberResponseModel {
  OrderCallInfoConfigModel? orderInfo;
  UserInfoConfigModel? userInfo;
  bool? success;

  OrderCallCustomerNumberResponseModel({this.orderInfo, this.userInfo, this.success});

  OrderCallCustomerNumberResponseModel.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null ? OrderCallInfoConfigModel.fromJson(json['orderInfo']) : null;
    userInfo = json['userInfo'] != null ? UserInfoConfigModel.fromJson(json['userInfo']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderInfo != null) {
      data['orderInfo'] = orderInfo!.toJson();
    }
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class OrderCallInfoConfigModel {
  String? user;
  String? orderTo;
  String? countryCode;
  String? receiverContact;
  String? id;

  OrderCallInfoConfigModel({this.user, this.orderTo, this.countryCode, this.receiverContact, this.id});

  OrderCallInfoConfigModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    orderTo = json['orderTo'];
    if (json['countryCode'] != null && json['countryCode'] != '') {
      countryCode = json['countryCode'].toString();
    } else {
      countryCode = '';
    }
    if (json['receiverContact'] != null && json['receiverContact'] != '') {
      receiverContact = json['receiverContact'].toString();
    } else {
      receiverContact = '';
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['orderTo'] = orderTo;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    data['id'] = id;
    return data;
  }
}

class UserInfoConfigModel {
  String? countryCode;
  String? mobile;
  String? id;

  UserInfoConfigModel({this.countryCode, this.mobile, this.id});

  UserInfoConfigModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'].toString();
    mobile = json['mobile'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['id'] = id;
    return data;
  }
}
