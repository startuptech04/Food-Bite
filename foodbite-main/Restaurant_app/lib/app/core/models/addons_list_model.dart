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

class AddonListModel {
  List<AddonResultModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;
  AddonListModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  AddonListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <AddonResultModel>[];
      json['results'].forEach((v) {
        results!.add(AddonResultModel.fromJson(v, locale));
      });
    }
    page = int.parse(json['page'].toString());
    limit = int.parse(json['limit'].toString());
    totalPages = int.parse(json['totalPages'].toString());
    totalResults = int.parse(json['totalResults'].toString());
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
    return data;
  }
}

class AddonResultModel {
  String? name;
  String? realName;
  double? price;
  String? restaurant;
  int? stockNumber;
  String? stockType;
  bool? inStock;
  List<Translations>? translations;
  bool? status;
  String? id;
  final String locale;
  AddonResultModel({this.name, this.realName, this.price, this.restaurant, this.stockNumber, this.stockType, this.inStock, this.translations, this.status, this.id, required this.locale});

  AddonResultModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    price = double.parse(json['price'].toString());
    restaurant = json['restaurant'];
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
    if (json['stockNumber'] != null && json['stockNumber'] != '') {
      stockNumber = int.parse(json['stockNumber'].toString());
    } else {
      stockNumber = -1;
    }
    if (json['stockType'] != null && json['stockType'] != '') {
      stockType = json['stockType'];
    } else {
      stockType = 'unlimited';
    }
    if (json['inStock'] != null && json['inStock'] != '') {
      inStock = json['inStock'];
    } else {
      inStock = true;
    }
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['realName'] = realName;
    data['price'] = price;
    data['restaurant'] = restaurant;
    data['stockNumber'] = stockNumber;
    data['stockType'] = stockType;
    data['inStock'] = inStock;
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
