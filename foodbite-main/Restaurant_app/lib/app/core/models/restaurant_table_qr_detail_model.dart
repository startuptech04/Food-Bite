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

class RestaurantTableQRDetailModel {
  RestaurantDetailConfigModel? detail;
  BusinessConfigModel? business;
  bool? success;
  final String locale;
  RestaurantTableQRDetailModel({this.detail, this.business, this.success, required this.locale});

  RestaurantTableQRDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    detail = json['detail'] != null ? RestaurantDetailConfigModel.fromJson(json['detail'], locale) : null;
    business = json['business'] != null ? BusinessConfigModel.fromJson(json['business']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    if (business != null) {
      data['business'] = business!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class RestaurantDetailConfigModel {
  String? name;
  String? logo;
  List<Translations>? translations;
  String? id;
  final String locale;
  RestaurantDetailConfigModel({this.name, this.logo, this.translations, this.id, required this.locale});

  RestaurantDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    logo = json['logo'];
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
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['logo'] = logo;
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
  String? title;
  String? address;
  String? shortDescription;

  Translations({this.name, this.code, this.nativeName, this.title, this.address, this.shortDescription});

  Translations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
    address = json['address'];
    shortDescription = json['shortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    data['address'] = address;
    data['shortDescription'] = shortDescription;
    return data;
  }
}

class BusinessConfigModel {
  String? companyName;
  String? mobile;
  String? websiteUrl;
  String? id;

  BusinessConfigModel({this.companyName, this.mobile, this.websiteUrl, this.id});

  BusinessConfigModel.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    mobile = json['mobile'];
    websiteUrl = json['websiteUrl'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['mobile'] = mobile;
    data['websiteUrl'] = websiteUrl;
    data['id'] = id;
    return data;
  }
}
