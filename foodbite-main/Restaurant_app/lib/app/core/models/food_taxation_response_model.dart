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

import 'package:vendor/app/core/models/translations/food_taxation_form_translation.dart';

class FoodTaxationResponseModel {
  List<TaxationConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;
  FoodTaxationResponseModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  FoodTaxationResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <TaxationConfigModel>[];
      json['results'].forEach((v) {
        results!.add(TaxationConfigModel.fromJson(v, locale));
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

class TaxationConfigModel {
  String? restaurant;
  String? taxName;
  String? realName;
  List<FoodTaxationFormTranslations>? translations;
  String? id;
  double? taxAmount;
  final String locale;
  TaxationConfigModel({this.restaurant, this.taxName, this.realName, this.translations, this.id, this.taxAmount, required this.locale});

  TaxationConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    restaurant = json['restaurant'];
    if (json['taxName'] != null && json['taxName'] != '') {
      realName = json['taxName'];
    } else {
      realName = '';
    }
    if (json['translations'] != null) {
      translations = <FoodTaxationFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(FoodTaxationFormTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            taxName = translations![localeIndex].title!;
          }
        }
      }
    } else {
      translations = [];
    }
    id = json['id'];
    if (json['taxAmount'] != null && json['taxAmount'] != '') {
      taxAmount = double.parse(json['taxAmount'].toString());
    } else {
      taxAmount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant'] = restaurant;
    data['taxName'] = taxName;
    data['realName'] = realName;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['taxAmount'] = taxAmount;
    return data;
  }
}
