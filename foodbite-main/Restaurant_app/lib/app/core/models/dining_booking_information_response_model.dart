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

class DiningBookingInformationResponseModel {
  DiningBookingInformationConfigModel? details;
  DiningSettingConfigModel? diningSettings;
  RestaurantConfigModel? restaurantConfig;
  bool? success;
  final String locale;
  DiningBookingInformationResponseModel({this.details, this.diningSettings, this.restaurantConfig, this.success, required this.locale});

  DiningBookingInformationResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    details = json['details'] != null ? DiningBookingInformationConfigModel.fromJson(json['details'], locale) : null;
    diningSettings = json['diningSettings'] != null ? DiningSettingConfigModel.fromJson(json['diningSettings']) : null;
    restaurantConfig = json['restaurantConfig'] != null ? RestaurantConfigModel.fromJson(json['restaurantConfig']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (diningSettings != null) {
      data['diningSettings'] = diningSettings!.toJson();
    }
    if (restaurantConfig != null) {
      data['restaurantConfig'] = restaurantConfig!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class DiningBookingInformationConfigModel {
  CouponInfoConfigModel? coupon;
  String? bookingDate;
  String? bookingSlot;
  int? guest;
  String? userName;
  String? userCountryCode;
  String? specialRequest;
  String? status;
  String? createdAt;
  String? id;
  String? userContact;
  String? userEmail;
  double? couponCoverCharge;
  double? preBookingCharge;
  double? grandTotal;
  UserInfoConfigModel? userInfo;
  PaymentInfoConfigModel? paymentInfo;
  final String locale;
  DiningBookingInformationConfigModel({
    this.coupon,
    this.bookingDate,
    this.bookingSlot,
    this.guest,
    this.userName,
    this.userCountryCode,
    this.specialRequest,
    this.status,
    this.createdAt,
    this.id,
    this.userContact,
    this.userEmail,
    this.couponCoverCharge,
    this.preBookingCharge,
    this.grandTotal,
    this.userInfo,
    this.paymentInfo,
    required this.locale,
  });

  DiningBookingInformationConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    coupon = json['coupon'] != null ? CouponInfoConfigModel.fromJson(json['coupon'], locale) : null;
    if (json['bookingDate'] != null && json['bookingDate'] != '') {
      DateTime dateTime = DateTime.parse(json['bookingDate']);
      String formattedDate = DateFormat('dd MMM yyyy', locale).format(dateTime);
      bookingDate = formattedDate;
    } else {
      DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat('dd MMM yyyy', locale).format(dateTime);
      bookingDate = formattedDate;
    }
    bookingSlot = json['bookingSlot'];
    if (json['guest'] != null && json['guest'] != '') {
      guest = int.parse(json['guest'].toString());
    } else {
      guest = 0;
    }
    userName = json['userName'];
    userCountryCode = json['userCountryCode'].toString();
    if (json['specialRequest'] != null && json['specialRequest'] != '') {
      specialRequest = json['specialRequest'];
    } else {
      specialRequest = '';
    }
    status = json['status'];
    createdAt = json['createdAt'];
    id = json['id'];
    userContact = json['userContact'];
    userEmail = json['userEmail'];
    if (json['couponCoverCharge'] != null && json['couponCoverCharge'] != '') {
      couponCoverCharge = double.parse(json['couponCoverCharge'].toString());
    } else {
      couponCoverCharge = 0;
    }
    if (json['preBookingCharge'] != null && json['preBookingCharge'] != '') {
      preBookingCharge = double.parse(json['preBookingCharge'].toString());
    } else {
      preBookingCharge = 0;
    }
    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0;
    }
    userInfo = json['userInfo'] != null ? UserInfoConfigModel.fromJson(json['userInfo']) : null;
    paymentInfo = json['paymentInfo'] != null ? PaymentInfoConfigModel.fromJson(json['paymentInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    data['bookingDate'] = bookingDate;
    data['bookingSlot'] = bookingSlot;
    data['guest'] = guest;
    data['userName'] = userName;
    data['userCountryCode'] = userCountryCode;
    data['specialRequest'] = specialRequest;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['userContact'] = userContact;
    data['userEmail'] = userEmail;
    data['couponCoverCharge'] = couponCoverCharge;
    data['preBookingCharge'] = preBookingCharge;
    data['grandTotal'] = grandTotal;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    if (paymentInfo != null) {
      data['paymentInfo'] = paymentInfo!.toJson();
    }
    return data;
  }
}

class CouponInfoConfigModel {
  String? id;
  String? name;
  String? code;
  String? discountType;
  double? minDiscount;
  double? maxDiscount;
  List<Translations>? translations;
  final String locale;
  CouponInfoConfigModel({this.id, this.name, this.code, this.discountType, this.minDiscount, this.maxDiscount, this.translations, required this.locale});

  CouponInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    discountType = json['discountType'];
    if (json['minDiscount'] != null && json['minDiscount'] != '') {
      minDiscount = double.parse(json['minDiscount'].toString());
    } else {
      minDiscount = 0;
    }
    if (json['maxDiscount'] != null && json['maxDiscount'] != '') {
      maxDiscount = double.parse(json['maxDiscount'].toString());
    } else {
      maxDiscount = 0;
    }
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
    data['code'] = code;
    data['discountType'] = discountType;
    data['minDiscount'] = minDiscount;
    data['maxDiscount'] = maxDiscount;
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

class UserInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? countryCode;
  String? contactNumber;
  String? contactEmail;
  String? role;

  UserInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.contactNumber, this.contactEmail, this.role});

  UserInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    contactNumber = json['contactNumber'];
    contactEmail = json['contactEmail'];
    role = json['role'];
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
    data['role'] = role;
    return data;
  }
}

class PaymentInfoConfigModel {
  String? id;
  String? slug;
  String? name;
  String? paymentWay;
  List<Translations>? translations;
  final String locale;
  PaymentInfoConfigModel({this.id, this.slug, this.name, this.paymentWay, this.translations, required this.locale});

  PaymentInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    paymentWay = json['paymentWay'];
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
    data['slug'] = slug;
    data['name'] = name;
    data['paymentWay'] = paymentWay;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiningSettingConfigModel {
  bool? restaurantCanCancelRequest;
  String? id;

  DiningSettingConfigModel({this.restaurantCanCancelRequest, this.id});

  DiningSettingConfigModel.fromJson(Map<String, dynamic> json) {
    restaurantCanCancelRequest = json['restaurantCanCancelRequest'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurantCanCancelRequest'] = restaurantCanCancelRequest;
    data['id'] = id;
    return data;
  }
}

class RestaurantConfigModel {
  bool? canInitiateChat;
  bool? canInitiateCall;
  String? id;

  RestaurantConfigModel({this.canInitiateChat, this.canInitiateCall, this.id});

  RestaurantConfigModel.fromJson(Map<String, dynamic> json) {
    canInitiateChat = json['canInitiateChat'];
    canInitiateCall = json['canInitiateCall'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['canInitiateChat'] = canInitiateChat;
    data['canInitiateCall'] = canInitiateCall;
    data['id'] = id;
    return data;
  }
}
