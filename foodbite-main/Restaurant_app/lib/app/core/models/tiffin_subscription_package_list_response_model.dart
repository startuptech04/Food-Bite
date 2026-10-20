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

class TiffinSubscriptionPackageListResponseModel {
  List<TiffinSubcriptionPackageConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  TiffinSubscriptionPackageListResponseModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  TiffinSubscriptionPackageListResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <TiffinSubcriptionPackageConfigModel>[];
      json['results'].forEach((v) {
        results!.add(TiffinSubcriptionPackageConfigModel.fromJson(v, locale));
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

class TiffinSubcriptionPackageConfigModel {
  String? name;
  String? image;
  List<String>? foods;
  String? interval;
  String? orderTo;
  String? available;
  String? discountType;
  List<Translations>? translations;
  String? status;
  String? id;
  int? totalPurchase;
  double? price;
  double? discount;
  final String locale;
  TiffinSubcriptionPackageConfigModel({
    this.name,
    this.image,
    this.foods,
    this.interval,
    this.orderTo,
    this.available,
    this.discountType,
    this.translations,
    this.status,
    this.id,
    this.totalPurchase,
    this.price,
    this.discount,
    required this.locale,
  });

  TiffinSubcriptionPackageConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    image = json['image'];
    foods = json['foods'].cast<String>();
    interval = json['interval'];
    orderTo = json['orderTo'];
    available = json['available'];
    discountType = json['discountType'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            name = translations![localeIndex].title!;
          }
        }
      }
    } else {
      translations = [];
    }
    status = json['status'];
    id = json['id'];
    if (json['totalPurchase'] != null && json['totalPurchase'] != '') {
      totalPurchase = int.parse(json['totalPurchase'].toString());
    } else {
      totalPurchase = 0;
    }
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0;
    }
    if (json['discount'] != null && json['discount'] != '') {
      discount = double.parse(json['discount'].toString());
    } else {
      discount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['foods'] = foods;
    data['interval'] = interval;
    data['orderTo'] = orderTo;
    data['available'] = available;
    data['discountType'] = discountType;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    data['totalPurchase'] = totalPurchase;
    data['price'] = price;
    data['discount'] = discount;
    return data;
  }
}

class Translations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  Translations({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  Translations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
    shortDescription = json['shortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    data['shortDescription'] = shortDescription;
    return data;
  }
}
