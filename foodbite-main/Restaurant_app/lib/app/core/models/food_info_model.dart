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

import 'package:vendor/app/core/models/food_variation_model.dart';

class FoodInfoModel {
  FoodInfoDetailModel? foodInfo;
  final String locale;
  FoodInfoModel({this.foodInfo, required this.locale});

  FoodInfoModel.fromJson(Map<String, dynamic> json, this.locale) {
    foodInfo = json['foodInfo'] != null ? FoodInfoDetailModel.fromJson(json['foodInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foodInfo != null) {
      data['foodInfo'] = foodInfo!.toJson();
    }
    return data;
  }
}

class FoodInfoDetailModel {
  String? name;
  String? shortDescription;
  String? image;
  String? restaurant;
  bool? ownCategory;
  CategoryModel? category;
  CategoryModel? subCategory;
  CategoryModel? customCategory;
  CategoryModel? customSubCategory;
  String? foodType;
  List<AddonModel>? addons;
  String? startTime;
  String? endTime;
  String? discountType;
  List<FoodVariationModel>? variations;
  List<String>? tags;
  List<FoodTranslations>? translations;
  int? purchaseLimit;
  String? id;
  double? price;
  double? discount;
  bool? taxationEnable;
  String? stockType;
  int? stockNumber;
  List<FoodTaxationConfigModel>? foodtaxations;
  final String locale;
  FoodInfoDetailModel({
    this.name,
    this.shortDescription,
    this.image,
    this.restaurant,
    this.ownCategory,
    this.category,
    this.subCategory,
    this.customCategory,
    this.customSubCategory,
    this.foodType,
    this.addons,
    this.startTime,
    this.endTime,
    this.discountType,
    this.variations,
    this.tags,
    this.translations,
    this.purchaseLimit,
    this.id,
    this.price,
    this.discount,
    this.taxationEnable,
    this.stockType,
    this.stockNumber,
    this.foodtaxations,
    required this.locale,
  });

  FoodInfoDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    shortDescription = json['shortDescription'];
    image = json['image'];
    restaurant = json['restaurant'];
    ownCategory = json['ownCategory'];
    category = json['category'] != null ? CategoryModel.fromJson(json['category'], locale) : null;
    subCategory = json['subCategory'] != null ? CategoryModel.fromJson(json['subCategory'], locale) : null;
    customCategory = json['customCategory'] != null ? CategoryModel.fromJson(json['customCategory'], locale) : null;
    customSubCategory = json['customSubCategory'] != null ? CategoryModel.fromJson(json['customSubCategory'], locale) : null;
    foodType = json['foodType'];
    if (json['addons'] != null) {
      addons = <AddonModel>[];
      json['addons'].forEach((v) {
        addons!.add(AddonModel.fromJson(v, locale));
      });
    } else {
      addons = [];
    }
    startTime = json['startTime'];
    endTime = json['endTime'];
    discountType = json['discountType'];
    if (json['variations'] != null) {
      variations = <FoodVariationModel>[];
      json['variations'].forEach((v) {
        variations!.add(FoodVariationModel.fromJson(v));
      });
    } else {
      variations = [];
    }
    if (json['tags'] != null) {
      tags = json['tags'].cast<String>();
    } else {
      tags = [];
    }

    if (json['translations'] != null) {
      translations = <FoodTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(FoodTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
    if (json['purchaseLimit'] != null && json['purchaseLimit'].toString().isNotEmpty) {
      purchaseLimit = int.parse(json['purchaseLimit'].toString());
    } else {
      purchaseLimit = -1;
    }

    id = json['id'];
    price = double.parse(json['price'].toString());
    discount = double.parse(json['discount'].toString());
    if (json['taxationEnable'] != null && json['taxationEnable'] != '') {
      taxationEnable = json['taxationEnable'];
    } else {
      taxationEnable = false;
    }
    if (json['stockType'] != null && json['stockType'] != '') {
      stockType = json['stockType'];
    } else {
      stockType = 'unlimited';
    }
    if (json['stockNumber'] != null && json['stockNumber'] != '') {
      stockNumber = int.parse(json['stockNumber'].toString());
    } else {
      stockNumber = -1;
    }
    if (json['foodtaxations'] != null) {
      foodtaxations = <FoodTaxationConfigModel>[];
      json['foodtaxations'].forEach((v) {
        foodtaxations!.add(FoodTaxationConfigModel.fromJson(v, locale));
      });
    } else {
      foodtaxations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['image'] = image;
    data['restaurant'] = restaurant;
    data['ownCategory'] = ownCategory;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['subCategory'] = subCategory!.toJson();
    }
    if (customCategory != null) {
      data['customCategory'] = customCategory!.toJson();
    }
    if (customSubCategory != null) {
      data['customSubCategory'] = customSubCategory!.toJson();
    }
    data['foodType'] = foodType;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['discountType'] = discountType;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['tags'] = tags;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['purchaseLimit'] = purchaseLimit;
    data['id'] = id;
    data['price'] = price;
    data['discount'] = discount;
    data['taxationEnable'] = taxationEnable;
    data['stockType'] = stockType;
    data['stockNumber'] = stockNumber;
    if (foodtaxations != null) {
      data['foodtaxations'] = foodtaxations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryModel {
  String? id;
  String? name;
  List<Translations>? translations;
  final String locale;
  CategoryModel({this.id, this.name, this.translations, required this.locale});

  CategoryModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
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

class AddonModel {
  String? id;
  String? name;
  List<Translations>? translations;
  final String locale;
  AddonModel({this.id, this.name, this.translations, required this.locale});

  AddonModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
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
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  FoodTranslations({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  FoodTranslations.fromJson(Map<String, dynamic> json) {
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

class FoodTaxationConfigModel {
  String? taxName;
  double? taxAmount;
  List<FoodTaxationTranslations>? translations;
  String? id;
  final String locale;
  FoodTaxationConfigModel({this.taxName, this.taxAmount, this.translations, this.id, required this.locale});

  FoodTaxationConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    taxName = json['taxName'];
    if (json['taxAmount'] != null && json['taxAmount'] != '') {
      taxAmount = double.parse(json['taxAmount'].toString());
    } else {
      taxAmount = 0;
    }
    if (json['translations'] != null) {
      translations = <FoodTaxationTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(FoodTaxationTranslations.fromJson(v));
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taxName'] = taxName;
    data['taxAmount'] = taxAmount;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class FoodTaxationTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;

  FoodTaxationTranslations({this.name, this.code, this.nativeName, this.title});

  FoodTaxationTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    return data;
  }
}
