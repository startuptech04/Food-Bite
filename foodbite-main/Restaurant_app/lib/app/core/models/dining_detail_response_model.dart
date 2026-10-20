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

class DiningDetailResponseModel {
  DiningRestaurantDetailConfigModel? restaurant;
  List<DiningMenuConfigModel>? menuDetail;
  List<String>? diningPhotos;
  bool? success;
  final String locale;
  DiningDetailResponseModel({this.restaurant, this.menuDetail, this.diningPhotos, this.success, required this.locale});

  DiningDetailResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    restaurant = json['restaurant'] != null ? DiningRestaurantDetailConfigModel.fromJson(json['restaurant'], locale) : null;
    if (json['menuDetail'] != null) {
      menuDetail = <DiningMenuConfigModel>[];
      json['menuDetail'].forEach((v) {
        menuDetail!.add(DiningMenuConfigModel.fromJson(v, locale));
      });
    }
    diningPhotos = json['diningPhotos'].cast<String>();
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    if (menuDetail != null) {
      data['menuDetail'] = menuDetail!.map((v) => v.toJson()).toList();
    }
    data['diningPhotos'] = diningPhotos;
    data['success'] = success;
    return data;
  }
}

class DiningRestaurantDetailConfigModel {
  List<DiningSavedCategoryConfigModel>? diningCategory;
  String? id;
  final String locale;

  DiningRestaurantDetailConfigModel({this.diningCategory, this.id, required this.locale});

  DiningRestaurantDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['diningCategory'] != null) {
      diningCategory = <DiningSavedCategoryConfigModel>[];
      json['diningCategory'].forEach((v) {
        diningCategory!.add(DiningSavedCategoryConfigModel.fromJson(v, locale));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (diningCategory != null) {
      data['diningCategory'] = diningCategory!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class DiningSavedCategoryConfigModel {
  String? name;
  List<DiningCategoryTranslations>? translations;
  String? id;
  final String locale;
  DiningSavedCategoryConfigModel({this.name, this.translations, this.id, required this.locale});

  DiningSavedCategoryConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <DiningCategoryTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(DiningCategoryTranslations.fromJson(v));
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

class DiningCategoryTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  DiningCategoryTranslations({this.name, this.code, this.nativeName, this.value});

  DiningCategoryTranslations.fromJson(Map<String, dynamic> json) {
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

class DiningMenuConfigModel {
  String? name;
  String? displayName;
  List<MenuTranslations>? translations;
  List<String>? photos;
  final String locale;
  DiningMenuConfigModel({this.name, this.displayName, this.translations, this.photos, required this.locale});

  DiningMenuConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <MenuTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(MenuTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            displayName = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
    photos = json['photos'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['displayName'] = displayName;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['photos'] = photos;
    return data;
  }
}

class MenuTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  MenuTranslations({this.name, this.code, this.nativeName, this.value});

  MenuTranslations.fromJson(Map<String, dynamic> json) {
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
