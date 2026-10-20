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

class OrderCouponListModel {
  List<CouponsConfigModel>? coupons;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;

  OrderCouponListModel({this.coupons, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  OrderCouponListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['coupons'] != null) {
      coupons = <CouponsConfigModel>[];
      json['coupons'].forEach((v) {
        coupons!.add(CouponsConfigModel.fromJson(v, locale));
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coupons != null) {
      data['coupons'] = coupons!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class CouponsConfigModel {
  String? name;
  String? realName;
  String? couponType;
  String? code;
  int? limitSameUser;
  String? start;
  String? expires;
  String? discountType;
  List<Translations>? translations;
  String? status;
  String? id;
  double? minDiscount;
  double? maxDiscount;
  double? minCartTotal;
  final String locale;
  CouponsConfigModel({
    this.name,
    this.realName,
    this.couponType,
    this.code,
    this.limitSameUser,
    this.start,
    this.expires,
    this.discountType,
    this.translations,
    this.status,
    this.id,
    this.minDiscount,
    this.maxDiscount,
    this.minCartTotal,
    required this.locale,
  });

  CouponsConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    couponType = json['couponType'];
    code = json['code'];
    if (json['limitSameUser'] != null && json['limitSameUser'] != '') {
      limitSameUser = int.parse(json['limitSameUser'].toString());
    } else {
      limitSameUser = 0;
    }
    if (json['start'] != null && json['start'] != '') {
      DateTime dateTime = DateTime.parse(json['start']);
      String formattedDate = DateFormat('d MMMM yyyy', locale).format(dateTime);
      start = formattedDate;
    } else {
      start = '15 July 1997';
    }
    if (json['expires'] != null && json['expires'] != '') {
      DateTime dateTime = DateTime.parse(json['expires']);
      String formattedDate = DateFormat('d MMMM yyyy', locale).format(dateTime);
      expires = formattedDate;
    } else {
      expires = '15 July 1997';
    }
    discountType = json['discountType'];
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
    if (json['minDiscount'] != null && json['minDiscount'] != '') {
      minDiscount = double.parse(json['minDiscount'].toString());
    } else {
      minDiscount = 0;
    }
    if (json['maxDiscount'] != null && json['maxDiscount'] != '') {
      maxDiscount = double.parse(json['maxDiscount'].toString());
    } else {
      maxDiscount = 0;
    }
    if (json['minCartTotal'] != null && json['minCartTotal'] != '') {
      minCartTotal = double.parse(json['minCartTotal'].toString());
    } else {
      minCartTotal = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['realName'] = realName;
    data['couponType'] = couponType;
    data['code'] = code;
    data['limitSameUser'] = limitSameUser;
    data['start'] = start;
    data['expires'] = expires;
    data['discountType'] = discountType;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    data['minDiscount'] = minDiscount;
    data['maxDiscount'] = maxDiscount;
    data['minCartTotal'] = minCartTotal;
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
