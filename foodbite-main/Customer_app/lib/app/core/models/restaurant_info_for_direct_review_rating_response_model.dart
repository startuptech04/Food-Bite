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

class RestaurantInfoForDirectReviewResponseModel {
  RestaurantInfoConfigModel? info;
  List<RestaurantMessagesConfigModel>? messages;
  OrderSettingConfigModel? orderSettings;
  bool? success;
  final String locale;

  RestaurantInfoForDirectReviewResponseModel({this.info, this.messages, this.orderSettings, this.success, required this.locale});

  RestaurantInfoForDirectReviewResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    info = json['info'] != null ? RestaurantInfoConfigModel.fromJson(json['info'], locale) : null;
    if (json['messages'] != null) {
      messages = <RestaurantMessagesConfigModel>[];
      json['messages'].forEach((v) {
        messages!.add(RestaurantMessagesConfigModel.fromJson(v, locale));
      });
    } else {
      messages = [];
    }
    orderSettings = json['orderSettings'] != null ? OrderSettingConfigModel.fromJson(json['orderSettings']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    if (orderSettings != null) {
      data['orderSettings'] = orderSettings!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class RestaurantInfoConfigModel {
  String? name;
  String? address;
  String? logo;
  String? cover;
  List<RestaurantTranslations>? translations;
  String? slug;
  String? id;
  final String locale;
  RestaurantInfoConfigModel({this.name, this.address, this.logo, this.cover, this.translations, this.slug, this.id, required this.locale});

  RestaurantInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    address = json['address'];
    logo = json['logo'];
    cover = json['cover'];
    if (json['translations'] != null) {
      translations = <RestaurantTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(RestaurantTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            name = translations![localeIndex].title!;
          }
          if (translations![localeIndex].address!.isNotEmpty) {
            address = translations![localeIndex].address!;
          }
        }
      }
    } else {
      translations = [];
    }
    slug = json['slug'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['logo'] = logo;
    data['cover'] = cover;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['slug'] = slug;
    data['id'] = id;
    return data;
  }
}

class RestaurantTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? address;
  String? shortDescription;

  RestaurantTranslations({this.name, this.code, this.nativeName, this.title, this.address, this.shortDescription});

  RestaurantTranslations.fromJson(Map<String, dynamic> json) {
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

class RestaurantMessagesConfigModel {
  String? name;
  int? rateNumber;
  String? type;
  List<RestaurantReviewMessageTranslations>? translations;
  bool? status;
  String? id;
  final String locale;
  RestaurantMessagesConfigModel({this.name, this.rateNumber, this.type, this.translations, this.status, this.id, required this.locale});

  RestaurantMessagesConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    rateNumber = json['rateNumber'];
    type = json['type'];
    if (json['translations'] != null) {
      translations = <RestaurantReviewMessageTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(RestaurantReviewMessageTranslations.fromJson(v));
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
    data['rateNumber'] = rateNumber;
    data['type'] = type;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class RestaurantReviewMessageTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  RestaurantReviewMessageTranslations({this.name, this.code, this.nativeName, this.value});

  RestaurantReviewMessageTranslations.fromJson(Map<String, dynamic> json) {
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

class OrderSettingConfigModel {
  String? ratingStyle;
  String? id;

  OrderSettingConfigModel({this.ratingStyle, this.id});

  OrderSettingConfigModel.fromJson(Map<String, dynamic> json) {
    ratingStyle = json['ratingStyle'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ratingStyle'] = ratingStyle;
    data['id'] = id;
    return data;
  }
}
