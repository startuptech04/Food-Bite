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

class AccountSubscriptionPackageInfoConfigModel {
  bool? expiring;
  String? name;
  String? date;
  List<SubscriptionPackageTranslations>? translations;
  final String locale;
  AccountSubscriptionPackageInfoConfigModel({this.expiring, this.name, this.date, this.translations, required this.locale});

  AccountSubscriptionPackageInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    expiring = json['expiring'];
    name = json['name'];
    if (json['date'] != null && json['date'] != '') {
      DateTime parsedDate = DateTime.parse(json['date']);
      date = DateFormat("dd MMM yyyy", locale).format(parsedDate);
    } else {
      date = '15 July 1997';
    }
    if (json['translations'] != null) {
      translations = <SubscriptionPackageTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(SubscriptionPackageTranslations.fromJson(v));
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expiring'] = expiring;
    data['name'] = name;
    data['date'] = date;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscriptionPackageTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescriptions;

  SubscriptionPackageTranslations({this.name, this.code, this.nativeName, this.title, this.shortDescriptions});

  SubscriptionPackageTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
    shortDescriptions = json['shortDescriptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    data['shortDescriptions'] = shortDescriptions;
    return data;
  }
}
