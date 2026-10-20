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

class FoodCampaignDetailsMyFoodListModel {
  List<FoodsInfoInCampaignModel>? foods;
  CampaignInfoModel? info;
  final String locale;
  FoodCampaignDetailsMyFoodListModel({this.foods, this.info, required this.locale});

  FoodCampaignDetailsMyFoodListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['foods'] != null) {
      foods = <FoodsInfoInCampaignModel>[];
      json['foods'].forEach((v) {
        foods!.add(FoodsInfoInCampaignModel.fromJson(v, locale));
      });
    }
    info = json['info'] != null ? CampaignInfoModel.fromJson(json['info'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    if (info != null) {
      data['info'] = info!.toJson();
    }
    return data;
  }
}

class FoodsInfoInCampaignModel {
  String? name;
  String? image;
  List<String>? addons;
  double? price;
  String? discountType;
  double? discount;
  String? restaurant;
  List<VariationsModel>? variations;
  List<Translations>? translations;
  String? status;
  String? id;
  final String locale;
  FoodsInfoInCampaignModel({this.name, this.image, this.addons, this.price, this.discountType, this.discount, this.restaurant, this.variations, this.translations, this.status, this.id, required this.locale});

  FoodsInfoInCampaignModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    image = json['image'];
    addons = json['addons'].cast<String>();
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0.0;
    }
    discountType = json['discountType'];
    if (json['discount'] != null && json['discount'] != '') {
      discount = double.parse(json['discount'].toString());
    } else {
      discount = 0.0;
    }
    restaurant = json['restaurant'];
    if (json['variations'] != null) {
      variations = <VariationsModel>[];
      json['variations'].forEach((v) {
        variations!.add(VariationsModel.fromJson(v));
      });
    }
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
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['addons'] = addons;
    data['price'] = price;
    data['discountType'] = discountType;
    data['discount'] = discount;
    data['restaurant'] = restaurant;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class VariationsModel {
  String? isRequired;
  String? title;
  String? type;
  String? min;
  String? max;
  List<Options>? options;

  VariationsModel({this.isRequired, this.title, this.type, this.min, this.max, this.options});

  VariationsModel.fromJson(Map<String, dynamic> json) {
    isRequired = json['isRequired'];
    title = json['title'];
    type = json['type'];
    min = json['min'];
    max = json['max'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequired'] = isRequired;
    data['title'] = title;
    data['type'] = type;
    data['min'] = min;
    data['max'] = max;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? name;
  String? price;

  Options({this.name, this.price});

  Options.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

class Translations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  Translations({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  Translations.fromJson(Map<String, dynamic> json) {
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

class CampaignInfoModel {
  String? title;
  String? shortDescription;
  String? city;
  List<FoodsInfoInCampaignModel>? foods;
  String? image;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  List<Translations>? translations;
  bool? status;
  String? id;
  final String locale;
  CampaignInfoModel({this.title, this.shortDescription, this.city, this.foods, this.image, this.startDate, this.endDate, this.startTime, this.endTime, this.translations, this.status, this.id, required this.locale});

  CampaignInfoModel.fromJson(Map<String, dynamic> json, this.locale) {
    title = json['title'];
    shortDescription = json['shortDescription'];
    city = json['city'];
    if (json['foods'] != null) {
      foods = <FoodsInfoInCampaignModel>[];
      json['foods'].forEach((v) {
        foods!.add(FoodsInfoInCampaignModel.fromJson(v, locale));
      });
    }
    image = json['image'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            title = translations![localeIndex].title!;
          }
          if (translations![localeIndex].shortDescription!.isNotEmpty) {
            shortDescription = translations![localeIndex].shortDescription!;
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
    data['title'] = title;
    data['shortDescription'] = shortDescription;
    data['city'] = city;
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    data['image'] = image;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
