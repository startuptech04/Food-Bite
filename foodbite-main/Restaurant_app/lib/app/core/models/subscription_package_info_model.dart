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

import 'package:intl/intl.dart';

class SubscriptionPackageInfoModel {
  SubscriberInfoConfigModel? info;
  List<PaymentConfigModel>? payments;
  PaymentConfigModel? primary;
  bool? expireSoon;
  bool? success;
  final String locale;
  SubscriptionPackageInfoModel({this.info, this.payments, this.primary, this.expireSoon, this.success, required this.locale});

  SubscriptionPackageInfoModel.fromJson(Map<String, dynamic> json, this.locale) {
    info = json['info'] != null ? SubscriberInfoConfigModel.fromJson(json['info'], locale) : null;
    if (json['payments'] != null) {
      payments = <PaymentConfigModel>[];
      json['payments'].forEach((v) {
        payments!.add(PaymentConfigModel.fromJson(v, locale));
      });
    } else {
      payments = [];
    }
    primary = json['primary'] != null ? PaymentConfigModel.fromJson(json['primary'], locale) : null;
    expireSoon = json['expireSoon'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (payments != null) {
      data['payments'] = payments!.map((v) => v.toJson()).toList();
    }
    if (primary != null) {
      data['primary'] = primary!.toJson();
    }
    data['expireSoon'] = expireSoon;
    data['success'] = success;
    return data;
  }
}

class SubscriberInfoConfigModel {
  String? trialStartDate;
  String? trialEndDate;
  String? startDate;
  String? endDate;
  String? id;
  SubscriptionPackageDetailConfigModel? subscriptionInfo;
  final String locale;

  SubscriberInfoConfigModel({this.trialStartDate, this.trialEndDate, this.startDate, this.endDate, this.id, this.subscriptionInfo, required this.locale});

  SubscriberInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['trialStartDate'] != null && json['trialStartDate'] != '') {
      DateTime parsedDate = DateTime.parse(json['trialStartDate']);
      trialStartDate = DateFormat("dd MMM yyyy", locale).format(parsedDate);
    } else {
      trialStartDate = '';
    }
    if (json['trialEndDate'] != null && json['trialEndDate'] != '') {
      DateTime parsedDate = DateTime.parse(json['trialEndDate']);
      trialEndDate = DateFormat("dd MMM yyyy", locale).format(parsedDate);
    } else {
      trialEndDate = '';
    }
    if (json['startDate'] != null && json['startDate'] != '') {
      DateTime parsedDate = DateTime.parse(json['startDate']);
      startDate = DateFormat("dd MMM yyyy", locale).format(parsedDate);
    } else {
      startDate = '';
    }
    if (json['endDate'] != null && json['endDate'] != '') {
      DateTime parsedDate = DateTime.parse(json['endDate']);
      endDate = DateFormat("dd MMM yyyy", locale).format(parsedDate);
    } else {
      endDate = '';
    }
    id = json['id'];
    subscriptionInfo = json['subscriptionInfo'] != null ? SubscriptionPackageDetailConfigModel.fromJson(json['subscriptionInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trialStartDate'] = trialStartDate;
    data['trialEndDate'] = trialEndDate;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['id'] = id;
    if (subscriptionInfo != null) {
      data['subscriptionInfo'] = subscriptionInfo!.toJson();
    }
    return data;
  }
}

class SubscriptionPackageDetailConfigModel {
  String? name;
  double? price;
  double? discount;
  double? offerPrice = 0.0;
  String? shortDescriptions;
  int? validity;
  bool? haveTrial;
  int? trialValidity;
  String? icon;
  bool? pos;
  bool? ownDriver;
  bool? promote;
  bool? customCategory;
  bool? multiOutlet;
  bool? preBooking;
  bool? tableOrder;
  int? orderLimit;
  int? productLimit;
  List<SubscriptionPackageTranslations>? translations;
  bool? status;
  String? slug;
  bool? tiffinSubscription;
  bool? ownWaiter;
  bool? ownKitchen;
  String? id;
  final String locale;
  SubscriptionPackageDetailConfigModel({
    this.name,
    this.price,
    this.discount,
    this.offerPrice,
    this.shortDescriptions,
    this.validity,
    this.haveTrial,
    this.trialValidity,
    this.icon,
    this.pos,
    this.ownDriver,
    this.promote,
    this.customCategory,
    this.multiOutlet,
    this.preBooking,
    this.tableOrder,
    this.orderLimit,
    this.productLimit,
    this.translations,
    this.status,
    this.slug,
    this.tiffinSubscription,
    this.ownWaiter,
    this.ownKitchen,
    this.id,
    required this.locale,
  });

  SubscriptionPackageDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0;
    }
    if (json['discount'] != null && json['discount'] != '') {
      discount = double.parse(json['discount'].toString());
      if (discount! > 0) {
        String discountValue = (double.parse(price.toString()) - (double.parse(price.toString()) * double.parse(json['discount'].toString()) / 100)).toStringAsFixed(2);
        offerPrice = double.parse(discountValue);
      }
    } else {
      discount = 0;
      offerPrice = 0.0;
    }
    shortDescriptions = json['shortDescriptions'];
    if (json['validity'] != null && json['validity'] != '') {
      validity = int.parse(json['validity'].toString());
    } else {
      validity = 0;
    }
    haveTrial = json['haveTrial'];
    if (json['trialValidity'] != null && json['trialValidity'] != '') {
      trialValidity = int.parse(json['trialValidity'].toString());
    } else {
      trialValidity = 0;
    }
    icon = json['icon'];
    pos = json['pos'];
    ownDriver = json['ownDriver'];
    promote = json['promote'];
    customCategory = json['customCategory'];
    multiOutlet = json['multiOutlet'];
    preBooking = json['preBooking'];
    tableOrder = json['tableOrder'];
    if (json['orderLimit'] != null && json['orderLimit'] != '') {
      orderLimit = int.parse(json['orderLimit'].toString());
    } else {
      orderLimit = 0;
    }
    if (json['productLimit'] != null && json['productLimit'] != '') {
      productLimit = int.parse(json['productLimit'].toString());
    } else {
      productLimit = 0;
    }
    if (json['translations'] != null) {
      translations = <SubscriptionPackageTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(SubscriptionPackageTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            name = translations![localeIndex].title!;
          }
          if (translations![localeIndex].shortDescriptions!.isNotEmpty) {
            shortDescriptions = translations![localeIndex].shortDescriptions!;
          }
        }
      }
    } else {
      translations = [];
    }
    status = json['status'];
    slug = json['slug'];
    tiffinSubscription = json['tiffinSubscription'];
    ownWaiter = json['ownWaiter'];
    ownKitchen = json['ownKitchen'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['discount'] = discount;
    data['shortDescriptions'] = shortDescriptions;
    data['validity'] = validity;
    data['haveTrial'] = haveTrial;
    data['trialValidity'] = trialValidity;
    data['icon'] = icon;
    data['pos'] = pos;
    data['ownDriver'] = ownDriver;
    data['promote'] = promote;
    data['customCategory'] = customCategory;
    data['multiOutlet'] = multiOutlet;
    data['preBooking'] = preBooking;
    data['tableOrder'] = tableOrder;
    data['orderLimit'] = orderLimit;
    data['productLimit'] = productLimit;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['slug'] = slug;
    data['tiffinSubscription'] = tiffinSubscription;
    data['ownWaiter'] = ownWaiter;
    data['ownKitchen'] = ownKitchen;
    data['id'] = id;
    return data;
  }
}

class SubscriptionPackageTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescriptions;

  SubscriptionPackageTranslations({this.name, this.code, this.nativeName, this.title, this.shortDescriptions});

  SubscriptionPackageTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
    shortDescriptions = json['shortDescriptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    data['shortDescriptions'] = shortDescriptions;
    return data;
  }
}

class PaymentConfigModel {
  String? name;
  String? slug;
  String? image;
  List<PaymentTranslations>? translations;
  bool? isDefault;
  String? id;
  final String locale;
  PaymentConfigModel({this.name, this.slug, this.image, this.translations, this.isDefault, this.id, required this.locale});

  PaymentConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    if (json['translations'] != null) {
      translations = <PaymentTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(PaymentTranslations.fromJson(v));
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
    isDefault = json['isDefault'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['isDefault'] = isDefault;
    data['id'] = id;
    return data;
  }
}

class PaymentTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  PaymentTranslations({this.name, this.code, this.nativeName, this.value});

  PaymentTranslations.fromJson(Map<String, dynamic> json) {
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
