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

class CategoriesModel {
  VendorCategoryModel? vendorCategory;
  MainCategoryModel? mainCategory;
  final String locale;
  CategoriesModel({this.vendorCategory, this.mainCategory, required this.locale});

  CategoriesModel.fromJson(Map<String, dynamic> json, this.locale) {
    vendorCategory = json['vendorCategory'] != null ? VendorCategoryModel.fromJson(json['vendorCategory'], locale) : null;
    mainCategory = json['mainCategory'] != null ? MainCategoryModel.fromJson(json['mainCategory'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vendorCategory != null) {
      data['vendorCategory'] = vendorCategory!.toJson();
    }
    if (mainCategory != null) {
      data['mainCategory'] = mainCategory!.toJson();
    }
    return data;
  }
}

class VendorCategoryModel {
  List<VendorCategoryResultModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;
  VendorCategoryModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  VendorCategoryModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <VendorCategoryResultModel>[];
      json['results'].forEach((v) {
        results!.add(VendorCategoryResultModel.fromJson(v, locale));
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

class MainCategoryModel {
  List<MainCategoryResultModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;
  MainCategoryModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  MainCategoryModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <MainCategoryResultModel>[];
      json['results'].forEach((v) {
        results!.add(MainCategoryResultModel.fromJson(v, locale));
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

class VendorCategoryResultModel {
  String? name;
  String? realName;
  String? image;
  String? restaurant;
  List<Translations>? translations;
  bool? status;
  String? id;
  final String locale;
  VendorCategoryResultModel({this.name, this.realName, this.image, this.restaurant, this.translations, this.status, this.id, required this.locale});

  VendorCategoryResultModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    image = json['image'];
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
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['realName'] = realName;
    data['image'] = image;
    data['restaurant'] = restaurant;
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

class MainCategoryResultModel {
  String? name;
  String? realName;
  String? image;
  List<Translations>? translations;
  bool? status;
  String? slug;
  String? id;
  final String locale;
  MainCategoryResultModel({this.name, this.realName, this.image, this.translations, this.status, this.slug, this.id, required this.locale});

  MainCategoryResultModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    image = json['image'];
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
    slug = json['slug'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['realName'] = realName;
    data['image'] = image;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['slug'] = slug;
    data['id'] = id;
    return data;
  }
}
