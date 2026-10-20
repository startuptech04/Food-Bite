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

class OrderCouponInfoResponseModel {
  OrderCouponInfoConfigModel? info;
  bool? success;
  final String locale;
  OrderCouponInfoResponseModel({this.info, this.success, required this.locale});

  OrderCouponInfoResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    info = json['info'] != null ? OrderCouponInfoConfigModel.fromJson(json['info'], locale) : null;
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

class OrderCouponInfoConfigModel {
  String? name;
  String? realName;
  String? code;
  int? limitSameUser;
  String? start;
  String? expires;
  String? discountType;
  double? minDiscount;
  double? maxDiscount;
  double? minCartTotal;
  List<Translations>? translations;
  String? id;
  final String locale;
  OrderCouponInfoConfigModel({
    this.name,
    this.realName,
    this.code,
    this.limitSameUser,
    this.start,
    this.expires,
    this.discountType,
    this.minDiscount,
    this.maxDiscount,
    this.minCartTotal,
    this.translations,
    this.id,
    required this.locale,
  });

  OrderCouponInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    code = json['code'];
    if (json['limitSameUser'] != null && json['limitSameUser'] != '') {
      limitSameUser = int.parse(json['limitSameUser'].toString());
    } else {
      limitSameUser = 0;
    }
    start = json['start'];
    expires = json['expires'];
    discountType = json['discountType'];
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
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['realName'] = realName;
    data['code'] = code;
    data['limitSameUser'] = limitSameUser;
    data['start'] = start;
    data['expires'] = expires;
    data['discountType'] = discountType;
    data['minDiscount'] = minDiscount;
    data['maxDiscount'] = maxDiscount;
    data['minCartTotal'] = minCartTotal;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
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
