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

import 'package:vendor/app/core/models/tiffin_subscription_instruction_list_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_timeslot_list_model.dart';
import 'package:vendor/app/core/models/translations/tiffin_subscription_form_translation.dart';

class TiffinSubscriptionInfoResponseModel {
  TiffinSubscriptionInfoConfigModel? info;
  List<TiffinSubscriptionFoodInPackageConfigModel>? food;
  final String locale;
  TiffinSubscriptionInfoResponseModel({this.info, this.food, required this.locale});

  TiffinSubscriptionInfoResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    info = json['info'] != null ? TiffinSubscriptionInfoConfigModel.fromJson(json['info'], locale) : null;
    if (json['food'] != null) {
      food = <TiffinSubscriptionFoodInPackageConfigModel>[];
      json['food'].forEach((v) {
        food!.add(TiffinSubscriptionFoodInPackageConfigModel.fromJson(v, locale));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (food != null) {
      data['food'] = food!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TiffinSubscriptionInfoConfigModel {
  String? name;
  String? realName;
  String? shortDescription;
  String? realShortDescription;
  String? image;
  String? restaurant;
  List<String>? foods;
  String? interval;
  List<String>? offDays;
  int? totalOrder;
  String? orderTo;
  double? deliveryArea;
  String? available;
  List<TiffinSubscriptionTimeSlotListModel>? timeSlots;
  bool? canSelectAddon;
  bool? canSelectVariation;
  String? discountType;
  List<TiffinSubscriptionInstructionModel>? notice;
  List<TiffinSubscriptionFormTransation>? translations;
  String? status;
  String? id;
  double? price;
  double? discount;
  final String locale;
  TiffinSubscriptionInfoConfigModel({
    this.name,
    this.realName,
    this.shortDescription,
    this.realShortDescription,
    this.image,
    this.restaurant,
    this.foods,
    this.interval,
    this.offDays,
    this.totalOrder,
    this.orderTo,
    this.deliveryArea,
    this.available,
    this.timeSlots,
    this.canSelectAddon,
    this.canSelectVariation,
    this.discountType,
    this.notice,
    this.translations,
    this.status,
    this.id,
    this.price,
    this.discount,
    required this.locale,
  });

  TiffinSubscriptionInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['name'] != null && json['name'] != '') {
      realName = json['name'];
    } else {
      realName = '';
    }
    shortDescription = json['shortDescription'];
    if (json['shortDescription'] != null && json['shortDescription'] != '') {
      realShortDescription = json['shortDescription'];
    } else {
      realShortDescription;
    }
    image = json['image'];
    restaurant = json['restaurant'];
    foods = json['foods'].cast<String>();
    interval = json['interval'];
    offDays = json['offDays'].cast<String>();
    if (json['totalOrder'] != null && json['totalOrder'] != '') {
      totalOrder = int.parse(json['totalOrder'].toString());
    } else {
      totalOrder = 0;
    }
    orderTo = json['orderTo'];
    if (json['deliveryArea'] != null && json['deliveryArea'] != '') {
      deliveryArea = double.parse(json['deliveryArea'].toString());
    } else {
      deliveryArea = 0;
    }
    available = json['available'];
    if (json['timeSlots'] != null) {
      timeSlots = <TiffinSubscriptionTimeSlotListModel>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(TiffinSubscriptionTimeSlotListModel.fromJson(v));
      });
    }
    canSelectAddon = json['canSelectAddon'];
    canSelectVariation = json['canSelectVariation'];
    discountType = json['discountType'];
    if (json['notice'] != null) {
      notice = <TiffinSubscriptionInstructionModel>[];
      json['notice'].forEach((v) {
        notice!.add(TiffinSubscriptionInstructionModel.fromJson(v, locale));
      });
    }
    if (json['translations'] != null) {
      translations = <TiffinSubscriptionFormTransation>[];
      json['translations'].forEach((v) {
        translations!.add(TiffinSubscriptionFormTransation.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            name = translations![localeIndex].title!;
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
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0;
    }
    if (json['discount'] != null && json['discount'] != '') {
      discount = double.parse(json['discount'].toString());
    } else {
      discount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['realName'] = realName;
    data['shortDescription'] = shortDescription;
    data['realShortDescription'] = realShortDescription;
    data['image'] = image;
    data['restaurant'] = restaurant;
    data['foods'] = foods;
    data['interval'] = interval;
    data['offDays'] = offDays;
    data['totalOrder'] = totalOrder;
    data['orderTo'] = orderTo;
    data['deliveryArea'] = deliveryArea;
    data['available'] = available;
    if (timeSlots != null) {
      data['timeSlots'] = timeSlots!.map((v) => v.toJson()).toList();
    }
    data['canSelectAddon'] = canSelectAddon;
    data['canSelectVariation'] = canSelectVariation;
    data['discountType'] = discountType;
    if (notice != null) {
      data['notice'] = notice!.map((v) => v.toJson()).toList();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    data['price'] = price;
    data['discount'] = discount;
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

class TiffinSubscriptionFoodInPackageConfigModel {
  String? name;
  String? image;
  String? discountType;
  List<Translations>? translations;
  String? id;
  double? price;
  double? discount;
  final String locale;
  TiffinSubscriptionFoodInPackageConfigModel({this.name, this.image, this.discountType, this.translations, this.id, this.price, this.discount, required this.locale});

  TiffinSubscriptionFoodInPackageConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    image = json['image'];
    discountType = json['discountType'];
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
    id = json['id'];
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0;
    }
    if (json['discount'] != null && json['discount'] != '') {
      discount = double.parse(json['discount'].toString());
    } else {
      discount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['discountType'] = discountType;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['price'] = price;
    data['discount'] = discount;
    return data;
  }
}
