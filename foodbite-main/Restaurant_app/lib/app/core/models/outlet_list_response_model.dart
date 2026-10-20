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

import 'package:vendor/app/core/models/translations/outlet_form_translation.dart';

class OutletListResponseModel {
  List<OutletConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  OutletListResponseModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  OutletListResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <OutletConfigModel>[];
      json['results'].forEach((v) {
        results!.add(OutletConfigModel.fromJson(v, locale));
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

class OutletConfigModel {
  String? name;
  List<CuisineConfigModel>? cuisine;
  String? logo;
  String? cover;
  CityConfigModel? city;
  LocalityConfigModel? locality;
  List<OutletFormTranslations>? translations;
  double? rating;
  bool? status;
  String? slug;
  String? id;
  int? totalRating;
  OwerInfoConfigModel? owerInfo;
  final String locale;
  OutletConfigModel({this.name, this.cuisine, this.logo, this.cover, this.city, this.locality, this.translations, this.rating, this.status, this.slug, this.id, this.totalRating, this.owerInfo, required this.locale});

  OutletConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['cuisine'] != null) {
      cuisine = <CuisineConfigModel>[];
      json['cuisine'].forEach((v) {
        cuisine!.add(CuisineConfigModel.fromJson(v, locale));
      });
    }
    logo = json['logo'];
    cover = json['cover'];
    city = json['city'] != null ? CityConfigModel.fromJson(json['city'], locale) : null;
    locality = json['locality'] != null ? LocalityConfigModel.fromJson(json['locality'], locale) : null;
    if (json['translations'] != null) {
      translations = <OutletFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(OutletFormTranslations.fromJson(v));
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
    if (json['rating'] != null && json['rating'] != '') {
      rating = double.parse(json['rating'].toString());
    } else {
      rating = 0;
    }
    status = json['status'];
    slug = json['slug'];
    id = json['id'];
    if (json['totalRating'] != null && json['totalRating'] != '') {
      totalRating = int.parse(json['totalRating'].toString());
    } else {
      totalRating = 0;
    }
    owerInfo = json['owerInfo'] != null ? OwerInfoConfigModel.fromJson(json['owerInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (cuisine != null) {
      data['cuisine'] = cuisine!.map((v) => v.toJson()).toList();
    }
    data['logo'] = logo;
    data['cover'] = cover;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (locality != null) {
      data['locality'] = locality!.toJson();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['rating'] = rating;
    data['status'] = status;
    data['slug'] = slug;
    data['id'] = id;
    data['totalRating'] = totalRating;
    if (owerInfo != null) {
      data['owerInfo'] = owerInfo!.toJson();
    }
    return data;
  }
}

class OwerInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? countryCode;
  String? contactNumber;
  String? contactEmail;

  OwerInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.contactNumber, this.contactEmail});

  OwerInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    contactNumber = json['contactNumber'];
    contactEmail = json['contactEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['contactNumber'] = contactNumber;
    data['contactEmail'] = contactEmail;
    return data;
  }
}

class CuisineConfigModel {
  String? name;
  List<CuisineTranslations>? translations;
  String? id;
  final String locale;
  CuisineConfigModel({this.name, this.translations, this.id, required this.locale});

  CuisineConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CuisineTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CuisineTranslations.fromJson(v));
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

class CuisineTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  CuisineTranslations({this.name, this.code, this.nativeName, this.value});

  CuisineTranslations.fromJson(Map<String, dynamic> json) {
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

class CityConfigModel {
  String? id;
  String? name;
  List<CityTranslations>? translations;
  final String locale;
  CityConfigModel({this.id, this.name, this.translations, required this.locale});

  CityConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CityTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CityTranslations.fromJson(v));
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

class CityTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  CityTranslations({this.name, this.code, this.nativeName, this.value});

  CityTranslations.fromJson(Map<String, dynamic> json) {
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

class LocalityConfigModel {
  String? id;
  String? name;
  List<LocalityTranslations>? translations;
  final String locale;
  LocalityConfigModel({this.id, this.name, this.translations, required this.locale});

  LocalityConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <LocalityTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(LocalityTranslations.fromJson(v));
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

class LocalityTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  LocalityTranslations({this.name, this.code, this.nativeName, this.value});

  LocalityTranslations.fromJson(Map<String, dynamic> json) {
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
