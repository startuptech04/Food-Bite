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

class OrderDetailForComplaintResponseModel {
  OrderDetailForComplaintConfigModel? details;
  List<OrderComplaintReasonConfigModel>? reason;
  bool? success;
  final String locale;

  OrderDetailForComplaintResponseModel({this.details, this.reason, this.success, required this.locale});

  OrderDetailForComplaintResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    details = json['details'] != null ? OrderDetailForComplaintConfigModel.fromJson(json['details']) : null;
    if (json['reason'] != null) {
      reason = <OrderComplaintReasonConfigModel>[];
      json['reason'].forEach((v) {
        reason!.add(OrderComplaintReasonConfigModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (reason != null) {
      data['reason'] = reason!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class OrderDetailForComplaintConfigModel {
  String? orderTo;
  String? status;
  String? id;
  DriverInfoConfigModel? driverInfo;
  UserInfoConfigModel? customer;

  OrderDetailForComplaintConfigModel({this.orderTo, this.status, this.id, this.driverInfo, this.customer});

  OrderDetailForComplaintConfigModel.fromJson(Map<String, dynamic> json) {
    orderTo = json['orderTo'];
    status = json['status'];
    id = json['id'];
    driverInfo = json['driverInfo'] != null ? DriverInfoConfigModel.fromJson(json['driverInfo']) : null;
    customer = json['customer'] != null ? UserInfoConfigModel.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderTo'] = orderTo;
    data['status'] = status;
    data['id'] = id;
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class DriverInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? role;

  DriverInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.role});

  DriverInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['role'] = role;
    return data;
  }
}

class UserInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? role;

  UserInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.role});

  UserInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['role'] = role;
    return data;
  }
}

class OrderComplaintReasonConfigModel {
  String? name;
  String? type;
  List<Translations>? translations;
  bool? status;
  String? id;
  final String locale;
  OrderComplaintReasonConfigModel({this.name, this.type, this.translations, this.status, this.id, required this.locale});

  OrderComplaintReasonConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    type = json['type'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            name = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class Translations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  Translations({this.name, this.code, this.nativeName, this.value});

  Translations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['value'] = value;
    return data;
  }
}
