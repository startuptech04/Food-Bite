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

class ExpenseModel {
  String? expenseType;
  String? createdAt;
  String? id;
  double? amount;
  ExpenseUserInfoConfigModel? userInfo;
  ExpenseOrderInfoConfigModel? orderInfo;
  ExpenseOrderInfoConfigModel? posOrderInfo;
  ExpenseOrderInfoConfigModel? tableOrderInfo;
  ExpenseBookingInfoConfigModel? bookingInfo;
  ExpenseCouponInfoConfigModel? couponInfo;
  ExpenseCouponInfoConfigModel? diningCouponInfo;
  final String locale;

  ExpenseModel({this.expenseType, this.createdAt, this.id, this.amount, this.userInfo, this.orderInfo, this.posOrderInfo, this.tableOrderInfo, this.bookingInfo, this.couponInfo, this.diningCouponInfo, required this.locale});

  ExpenseModel.fromJson(Map<String, dynamic> json, this.locale) {
    expenseType = json['expenseType'];
    if (json['createdAt'] != null && json['createdAt'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '-';
    }
    id = json['id'];
    if (json['amount'] != null && json['amount'] != '') {
      amount = double.parse(json['amount'].toString());
    } else {
      amount = 0;
    }
    userInfo = json['userInfo'] != null ? ExpenseUserInfoConfigModel.fromJson(json['userInfo']) : null;
    orderInfo = json['orderInfo'] != null ? ExpenseOrderInfoConfigModel.fromJson(json['orderInfo']) : null;
    posOrderInfo = json['posOrderInfo'] != null ? ExpenseOrderInfoConfigModel.fromJson(json['posOrderInfo']) : null;
    tableOrderInfo = json['tableOrderInfo'] != null ? ExpenseOrderInfoConfigModel.fromJson(json['tableOrderInfo']) : null;
    bookingInfo = json['bookingInfo'] != null ? ExpenseBookingInfoConfigModel.fromJson(json['bookingInfo']) : null;
    couponInfo = json['couponInfo'] != null ? ExpenseCouponInfoConfigModel.fromJson(json['couponInfo'], locale) : null;
    diningCouponInfo = json['diningCouponInfo'] != null ? ExpenseCouponInfoConfigModel.fromJson(json['diningCouponInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expenseType'] = expenseType;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['amount'] = amount;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    if (orderInfo != null) {
      data['orderInfo'] = orderInfo!.toJson();
    }
    if (posOrderInfo != null) {
      data['posOrderInfo'] = posOrderInfo!.toJson();
    }
    if (tableOrderInfo != null) {
      data['tableOrderInfo'] = tableOrderInfo!.toJson();
    }
    if (bookingInfo != null) {
      data['bookingInfo'] = bookingInfo!.toJson();
    }
    if (couponInfo != null) {
      data['couponInfo'] = couponInfo!.toJson();
    }
    if (diningCouponInfo != null) {
      data['diningCouponInfo'] = diningCouponInfo!.toJson();
    }
    return data;
  }
}

class ExpenseUserInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;

  ExpenseUserInfoConfigModel({this.id, this.firstName, this.lastName});

  ExpenseUserInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    return data;
  }
}

class ExpenseOrderInfoConfigModel {
  String? id;
  int? orderNo;

  ExpenseOrderInfoConfigModel({this.id, this.orderNo});

  ExpenseOrderInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderNo'] = orderNo;
    return data;
  }
}

class ExpenseBookingInfoConfigModel {
  String? id;

  ExpenseBookingInfoConfigModel({this.id});

  ExpenseBookingInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class ExpenseCouponInfoConfigModel {
  String? id;
  String? name;
  String? code;
  List<Translations>? translations;
  final String locale;
  ExpenseCouponInfoConfigModel({this.id, this.name, this.code, this.translations, required this.locale});

  ExpenseCouponInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
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
    data['name'] = name;
    data['code'] = code;
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
