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

import 'package:kitchen/app/core/models/food_variation_model.dart';

class FoodDetailResponseModel {
  FoodDetailConfigModel? detail;
  bool? success;
  final String locale;

  FoodDetailResponseModel({this.detail, this.success, required this.locale});

  FoodDetailResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    detail = json['detail'] != null ? FoodDetailConfigModel.fromJson(json['detail'], locale) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class FoodDetailConfigModel {
  String? name;
  String? shortDescription;
  String? image;
  List<AddonConfigModel>? addons;
  String? startTime;
  String? endTime;
  int? purchaseLimit;
  List<FoodVariationModel>? variations;
  String? stockType;
  int? stockNumber;
  String? id;
  final String locale;

  FoodDetailConfigModel({this.name, this.shortDescription, this.image, this.addons, this.startTime, this.endTime, this.purchaseLimit, this.variations, this.stockType, this.stockNumber, this.id, required this.locale});

  FoodDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    shortDescription = json['shortDescription'];
    image = json['image'];
    if (json['addons'] != null) {
      addons = <AddonConfigModel>[];
      json['addons'].forEach((v) {
        addons!.add(AddonConfigModel.fromJson(v, locale));
      });
    } else {
      addons = [];
    }
    startTime = json['startTime'];
    endTime = json['endTime'];
    purchaseLimit = json['purchaseLimit'];
    if (json['variations'] != null) {
      variations = <FoodVariationModel>[];
      json['variations'].forEach((v) {
        variations!.add(FoodVariationModel.fromJson(v));
      });
    } else {
      variations = [];
    }
    stockType = json['stockType'];
    stockNumber = json['stockNumber'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['image'] = image;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['purchaseLimit'] = purchaseLimit;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['stockType'] = stockType;
    data['stockNumber'] = stockNumber;
    data['id'] = id;
    return data;
  }
}

class AddonConfigModel {
  String? name;
  List<AddonTranslations>? translations;
  String? id;
  final String locale;

  AddonConfigModel({this.name, this.translations, this.id, required this.locale});

  AddonConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <AddonTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(AddonTranslations.fromJson(v));
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
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class AddonTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  AddonTranslations({this.name, this.code, this.nativeName, this.value});

  AddonTranslations.fromJson(Map<String, dynamic> json) {
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
