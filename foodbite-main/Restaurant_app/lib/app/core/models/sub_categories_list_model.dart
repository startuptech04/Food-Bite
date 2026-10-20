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

class SubCategoriesModel {
  VendorSubCategoryModel? vendorCategory;
  MainSubCategoryModel? mainCategory;
  final String locale;
  SubCategoriesModel({this.vendorCategory, this.mainCategory, required this.locale});

  SubCategoriesModel.fromJson(Map<String, dynamic> json, this.locale) {
    vendorCategory = json['vendorCategory'] != null ? VendorSubCategoryModel.fromJson(json['vendorCategory'], locale) : null;
    mainCategory = json['mainCategory'] != null ? MainSubCategoryModel.fromJson(json['mainCategory'], locale) : null;
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

class MainSubCategoryModel {
  List<MainSubCategoryResultModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;

  MainSubCategoryModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  MainSubCategoryModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <MainSubCategoryResultModel>[];
      json['results'].forEach((v) {
        results!.add(MainSubCategoryResultModel.fromJson(v, locale));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
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

class VendorSubCategoryModel {
  List<CustomSubCategoryResultModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;

  VendorSubCategoryModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  VendorSubCategoryModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <CustomSubCategoryResultModel>[];
      json['results'].forEach((v) {
        results!.add(CustomSubCategoryResultModel.fromJson(v, locale));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
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

class CustomSubCategoryResultModel {
  String? name;
  String? realName;
  CustomCategoryModel? category;
  String? restaurant;
  List<Translations>? translations;
  bool? status;
  String? id;
  final String locale;
  CustomSubCategoryResultModel({this.name, this.realName, this.category, this.restaurant, this.translations, this.status, this.id, required this.locale});

  CustomSubCategoryResultModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    category = json['category'] != null ? CustomCategoryModel.fromJson(json['category'], locale) : null;
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
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['restaurant'] = restaurant;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class CustomCategoryModel {
  String? name;
  List<Translations>? translations;
  String? id;
  final String locale;
  CustomCategoryModel({this.name, this.translations, this.id, required this.locale});

  CustomCategoryModel.fromJson(Map<String, dynamic> json, this.locale) {
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

class MainSubCategoryResultModel {
  String? name;
  String? realName;
  MainCategoryModel? category;
  List<Translations>? translations;
  bool? status;
  String? slug;
  String? id;
  final String locale;
  MainSubCategoryResultModel({this.name, this.realName, this.category, this.translations, this.status, this.slug, this.id, required this.locale});

  MainSubCategoryResultModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    category = json['category'] != null ? MainCategoryModel.fromJson(json['category'], locale) : null;
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
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['slug'] = slug;
    data['id'] = id;
    return data;
  }
}

class MainCategoryModel {
  String? name;
  List<Translations>? translations;
  String? id;
  final String locale;
  MainCategoryModel({this.name, this.translations, this.id, required this.locale});

  MainCategoryModel.fromJson(Map<String, dynamic> json, this.locale) {
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
