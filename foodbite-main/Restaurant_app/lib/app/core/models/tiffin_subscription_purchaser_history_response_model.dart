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

import 'package:intl/intl.dart';

class TiffinSubscriptionPurchaserHistoryResponseModel {
  List<TiffinSubscriptionPurchaseHistoryConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  TiffinSubscriptionPurchaserHistoryResponseModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  TiffinSubscriptionPurchaserHistoryResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <TiffinSubscriptionPurchaseHistoryConfigModel>[];
      json['results'].forEach((v) {
        results!.add(TiffinSubscriptionPurchaseHistoryConfigModel.fromJson(v, locale));
      });
    }
    if (json['page'] != null && json['page'] != '') {
      page = int.parse(json['page'].toString());
    } else {
      page = 0;
    }
    if (json['limit'] != null && json['limit'] != '') {
      limit = int.parse(json['limit'].toString());
    } else {
      limit = 0;
    }
    if (json['totalPages'] != null && json['totalPages'] != '') {
      totalPages = int.parse(json['totalPages'].toString());
    } else {
      totalPages = 0;
    }
    if (json['totalResults'] != null && json['totalResults'] != '') {
      totalResults = int.parse(json['totalResults'].toString());
    } else {
      totalResults = 0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class TiffinSubscriptionPurchaseHistoryConfigModel {
  String? orderAt;
  String? orderTo;
  int? totalOrder;
  String? startDate;
  List<String>? ordersDates;
  String? status;
  String? id;
  double? grandTotal;
  UserInfoInfoConfigModel? userInfo;
  PaymentInfoConfigModel? paymentInfo;
  final String locale;
  TiffinSubscriptionPurchaseHistoryConfigModel({this.orderAt, this.orderTo, this.totalOrder, this.startDate, this.ordersDates, this.status, this.id, this.grandTotal, this.userInfo, this.paymentInfo, required this.locale});

  TiffinSubscriptionPurchaseHistoryConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    orderAt = json['orderAt'];
    orderTo = json['orderTo'];
    if (json['totalOrder'] != null && json['totalOrder'] != '') {
      totalOrder = int.parse(json['totalOrder'].toString());
    } else {
      totalOrder = 0;
    }
    if (json['startDate'] != null && json['startDate'] != '') {
      DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['startDate']);
      startDate = DateFormat.yMMMMd(locale).format(tempDate);
    } else {
      startDate = '';
    }
    ordersDates = json['ordersDates'].cast<String>();
    status = json['status'];
    id = json['id'];
    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0;
    }
    userInfo = json['userInfo'] != null ? UserInfoInfoConfigModel.fromJson(json['userInfo']) : null;
    paymentInfo = json['paymentInfo'] != null ? PaymentInfoConfigModel.fromJson(json['paymentInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderAt'] = orderAt;
    data['orderTo'] = orderTo;
    data['totalOrder'] = totalOrder;
    data['startDate'] = startDate;
    data['ordersDates'] = ordersDates;
    data['status'] = status;
    data['id'] = id;
    data['grandTotal'] = grandTotal;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    if (paymentInfo != null) {
      data['paymentInfo'] = paymentInfo!.toJson();
    }
    return data;
  }
}

class UserInfoInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? countryCode;
  String? contactNumber;
  String? role;

  UserInfoInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.contactNumber, this.role});

  UserInfoInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    contactNumber = json['contactNumber'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['contactNumber'] = contactNumber;
    data['role'] = role;
    return data;
  }
}

class PaymentInfoConfigModel {
  String? id;
  String? slug;
  String? name;
  String? paymentWay;
  List<Translations>? translations;
  final String locale;
  PaymentInfoConfigModel({this.id, this.slug, this.name, this.paymentWay, this.translations, required this.locale});

  PaymentInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    paymentWay = json['paymentWay'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['paymentWay'] = paymentWay;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
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
