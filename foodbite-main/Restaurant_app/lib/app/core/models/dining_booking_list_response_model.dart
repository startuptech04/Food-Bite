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

class DiningBookingResponseListModel {
  List<DiningBookingConfigModel>? bookings;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  int? createdBooking;
  int? acceptedBooking;
  int? completedBooking;
  int? cancelledBooking;
  int? rejectedBooking;
  int? refundedBooking;
  int? partialRefundedBooking;
  DiningSettingConfigModel? diningSettings;
  bool? success;
  final String locale;
  DiningBookingResponseListModel({
    this.bookings,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
    this.createdBooking,
    this.acceptedBooking,
    this.completedBooking,
    this.cancelledBooking,
    this.rejectedBooking,
    this.refundedBooking,
    this.partialRefundedBooking,
    this.diningSettings,
    this.success,
    required this.locale,
  });

  DiningBookingResponseListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['bookings'] != null) {
      bookings = <DiningBookingConfigModel>[];
      json['bookings'].forEach((v) {
        bookings!.add(DiningBookingConfigModel.fromJson(v, locale));
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
    if (json['createdBooking'] != null && json['createdBooking'] != '') {
      createdBooking = int.parse(json['createdBooking'].toString());
    } else {
      createdBooking = 0;
    }
    if (json['acceptedBooking'] != null && json['acceptedBooking'] != '') {
      acceptedBooking = int.parse(json['acceptedBooking'].toString());
    } else {
      acceptedBooking = 0;
    }
    if (json['completedBooking'] != null && json['completedBooking'] != '') {
      completedBooking = int.parse(json['completedBooking'].toString());
    } else {
      completedBooking = 0;
    }
    if (json['cancelledBooking'] != null && json['cancelledBooking'] != '') {
      cancelledBooking = int.parse(json['cancelledBooking'].toString());
    } else {
      cancelledBooking = 0;
    }
    if (json['rejectedBooking'] != null && json['rejectedBooking'] != '') {
      rejectedBooking = int.parse(json['rejectedBooking'].toString());
    } else {
      rejectedBooking = 0;
    }
    if (json['refundedBooking'] != null && json['refundedBooking'] != '') {
      refundedBooking = int.parse(json['refundedBooking'].toString());
    } else {
      refundedBooking = 0;
    }
    if (json['partialRefundedBooking'] != null && json['partialRefundedBooking'] != '') {
      partialRefundedBooking = int.parse(json['partialRefundedBooking'].toString());
    } else {
      partialRefundedBooking = 0;
    }
    diningSettings = json['diningSettings'] != null ? DiningSettingConfigModel.fromJson(json['diningSettings']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['createdBooking'] = createdBooking;
    data['acceptedBooking'] = acceptedBooking;
    data['completedBooking'] = completedBooking;
    data['cancelledBooking'] = cancelledBooking;
    data['rejectedBooking'] = rejectedBooking;
    data['refundedBooking'] = refundedBooking;
    data['partialRefundedBooking'] = partialRefundedBooking;
    if (diningSettings != null) {
      data['diningSettings'] = diningSettings!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class DiningBookingConfigModel {
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
  DiningCouponConfigModel? coupon;
  final String locale;
  DiningBookingConfigModel({
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
    this.coupon,
    required this.locale,
  });

  DiningBookingConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
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
      guest = 1;
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
    coupon = json['coupon'] != null ? DiningCouponConfigModel.fromJson(json['coupon'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
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
  String? role;

  UserInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.contactNumber, this.role});

  UserInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    contactNumber = json['contactNumber'];
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

class DiningCouponConfigModel {
  String? id;
  String? name;
  String? code;
  String? discountType;
  double? minDiscount;
  double? maxDiscount;
  List<DiningCouponTranslations>? translations;
  final String locale;
  DiningCouponConfigModel({this.id, this.name, this.code, this.discountType, this.minDiscount, this.maxDiscount, this.translations, required this.locale});

  DiningCouponConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
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
      translations = <DiningCouponTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(DiningCouponTranslations.fromJson(v));
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

class DiningCouponTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  DiningCouponTranslations({this.name, this.code, this.nativeName, this.value});

  DiningCouponTranslations.fromJson(Map<String, dynamic> json) {
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
