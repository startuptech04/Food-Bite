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

class OrderCallDeliverymanNumberResponseModel {
  OrderInfoConfigModel? orderInfo;
  DriverInfoConfigModel? driverInfo;
  bool? success;

  OrderCallDeliverymanNumberResponseModel({this.orderInfo, this.driverInfo, this.success});

  OrderCallDeliverymanNumberResponseModel.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null ? OrderInfoConfigModel.fromJson(json['orderInfo']) : null;
    driverInfo = json['driverInfo'] != null ? DriverInfoConfigModel.fromJson(json['driverInfo']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderInfo != null) {
      data['orderInfo'] = orderInfo!.toJson();
    }
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class OrderInfoConfigModel {
  String? driver;
  String? id;

  OrderInfoConfigModel({this.driver, this.id});

  OrderInfoConfigModel.fromJson(Map<String, dynamic> json) {
    driver = json['driver'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver'] = driver;
    data['id'] = id;
    return data;
  }
}

class DriverInfoConfigModel {
  String? countryCode;
  String? mobile;
  String? id;

  DriverInfoConfigModel({this.countryCode, this.mobile, this.id});

  DriverInfoConfigModel.fromJson(Map<String, dynamic> json) {
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
