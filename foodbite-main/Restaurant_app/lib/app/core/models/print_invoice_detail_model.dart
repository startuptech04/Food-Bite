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
import 'package:vendor/app/core/models/food_in_cart_model.dart';

class PrintInvoiceDetailModel {
  OrderDetailConfigModel? details;
  BusinessSettingConfigModel? businessSettings;
  bool? success;
  final String locale;
  PrintInvoiceDetailModel({this.details, this.businessSettings, this.success, required this.locale});

  PrintInvoiceDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    details = json['details'] != null ? OrderDetailConfigModel.fromJson(json['details'], locale) : null;
    businessSettings = json['businessSettings'] != null ? BusinessSettingConfigModel.fromJson(json['businessSettings']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (businessSettings != null) {
      data['businessSettings'] = businessSettings!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class OrderDetailConfigModel {
  int? orderNo;
  String? user;
  RestaurantDetailConfigModel? restaurant;
  String? orderTo;
  String? receiverName;
  String? countryCode;
  String? receiverContact;
  bool? instantOrder;
  bool? scheduleOrder;
  String? scheduleDate;
  String? orderAt;
  String? scheduleTime;
  String? status;
  String? createdAt;
  String? id;
  DeliveryAddressRawConfigModel? deliveryAddressRaw;
  List<FoodInCartModel>? cartItem;
  double? grandTotal;
  double? realTotal;
  double? itemTotal;
  double? itemDiscount;
  double? couponDiscountCharge;
  double? deliveryCharge;
  double? foodServiceCharge;
  double? serviceCharge;
  double? packageCharge;
  double? packageChargeTax;
  double? walletAmount;
  double? deliveryTip;
  double? extraCharge;
  PaymentInfoConfigModel? paymentInfo;
  final String locale;
  OrderDetailConfigModel({
    this.orderNo,
    this.user,
    this.restaurant,
    this.orderTo,
    this.receiverName,
    this.countryCode,
    this.receiverContact,
    this.instantOrder,
    this.scheduleOrder,
    this.scheduleDate,
    this.orderAt,
    this.scheduleTime,
    this.status,
    this.createdAt,
    this.id,
    this.deliveryAddressRaw,
    this.cartItem,
    this.grandTotal,
    this.realTotal,
    this.itemTotal,
    this.itemDiscount,
    this.couponDiscountCharge,
    this.deliveryCharge,
    this.foodServiceCharge,
    this.serviceCharge,
    this.packageCharge,
    this.packageChargeTax,
    this.walletAmount,
    this.deliveryTip,
    this.extraCharge,
    this.paymentInfo,
    required this.locale,
  });

  OrderDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    user = json['user'];
    restaurant = json['restaurant'] != null ? RestaurantDetailConfigModel.fromJson(json['restaurant'], locale) : null;
    orderTo = json['orderTo'];
    receiverName = json['receiverName'];
    if (json['countryCode'] != null && json['countryCode'] != '') {
      countryCode = json['countryCode'].toString();
    } else {
      countryCode = '';
    }
    receiverContact = json['receiverContact'];
    instantOrder = json['instantOrder'];
    scheduleOrder = json['scheduleOrder'];
    if (json['scheduleDate'] != null && json['scheduleDate'] != '') {
      DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['scheduleDate']);
      scheduleDate = DateFormat.yMMMMd(locale).format(tempDate);
    } else {
      scheduleDate = '';
    }
    orderAt = json['orderAt'];
    scheduleTime = json['scheduleTime'];
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'] != '') {
      DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      createdAt = DateFormat.yMMMMd(locale).format(tempDate);
    } else {
      createdAt = '';
    }
    id = json['id'];
    deliveryAddressRaw = json['deliveryAddressRaw'] != null ? DeliveryAddressRawConfigModel.fromJson(json['deliveryAddressRaw']) : null;
    if (json['cartItem'] != null) {
      cartItem = <FoodInCartModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(FoodInCartModel.fromJson(v, locale));
      });
    } else {
      cartItem = [];
    }
    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0;
    }
    if (json['realTotal'] != null && json['realTotal'] != '') {
      realTotal = double.parse(json['realTotal'].toString());
    } else {
      realTotal = 0;
    }
    if (json['itemTotal'] != null && json['itemTotal'] != '') {
      itemTotal = double.parse(json['itemTotal'].toString());
    } else {
      itemTotal = 0;
    }
    if (json['itemDiscount'] != null && json['itemDiscount'] != '') {
      itemDiscount = double.parse(json['itemDiscount'].toString());
    } else {
      itemDiscount = 0;
    }
    if (json['couponDiscountCharge'] != null && json['couponDiscountCharge'] != '') {
      couponDiscountCharge = double.parse(json['couponDiscountCharge'].toString());
    } else {
      couponDiscountCharge = 0;
    }
    if (json['deliveryCharge'] != null && json['deliveryCharge'] != '') {
      deliveryCharge = double.parse(json['deliveryCharge'].toString());
    } else {
      deliveryCharge = 0;
    }
    if (json['foodServiceCharge'] != null && json['foodServiceCharge'] != '') {
      foodServiceCharge = double.parse(json['foodServiceCharge'].toString());
    } else {
      foodServiceCharge = 0;
    }
    if (json['serviceCharge'] != null && json['serviceCharge'] != '') {
      serviceCharge = double.parse(json['serviceCharge'].toString());
    } else {
      serviceCharge = 0;
    }
    if (json['packageCharge'] != null && json['packageCharge'] != '') {
      packageCharge = double.parse(json['packageCharge'].toString());
    } else {
      packageCharge = 0;
    }
    if (json['packageChargeTax'] != null && json['packageChargeTax'] != '') {
      packageChargeTax = double.parse(json['packageChargeTax'].toString());
    } else {
      packageChargeTax = 0;
    }
    if (json['walletAmount'] != null && json['walletAmount'] != '') {
      walletAmount = double.parse(json['walletAmount'].toString());
    } else {
      walletAmount = 0;
    }
    if (json['deliveryTip'] != null && json['deliveryTip'] != '') {
      deliveryTip = double.parse(json['deliveryTip'].toString());
    } else {
      deliveryTip = 0;
    }
    if (json['extraCharge'] != null && json['extraCharge'] != '') {
      extraCharge = double.parse(json['extraCharge'].toString());
    } else {
      extraCharge = 0;
    }
    paymentInfo = json['paymentInfo'] != null ? PaymentInfoConfigModel.fromJson(json['paymentInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderNo'] = orderNo;
    data['user'] = user;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['orderTo'] = orderTo;
    data['receiverName'] = receiverName;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    data['instantOrder'] = instantOrder;
    data['scheduleOrder'] = scheduleOrder;
    data['scheduleDate'] = scheduleDate;
    data['orderAt'] = orderAt;
    data['scheduleTime'] = scheduleTime;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    if (deliveryAddressRaw != null) {
      data['deliveryAddressRaw'] = deliveryAddressRaw!.toJson();
    }
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    data['grandTotal'] = grandTotal;
    data['realTotal'] = realTotal;
    data['itemTotal'] = itemTotal;
    data['itemDiscount'] = itemDiscount;
    data['couponDiscountCharge'] = couponDiscountCharge;
    data['deliveryCharge'] = deliveryCharge;
    data['foodServiceCharge'] = foodServiceCharge;
    data['serviceCharge'] = serviceCharge;
    data['packageCharge'] = packageCharge;
    data['packageChargeTax'] = packageChargeTax;
    data['walletAmount'] = walletAmount;
    data['deliveryTip'] = deliveryTip;
    data['extraCharge'] = extraCharge;
    if (paymentInfo != null) {
      data['paymentInfo'] = paymentInfo!.toJson();
    }
    return data;
  }
}

class RestaurantDetailConfigModel {
  String? id;
  String? name;
  String? address;
  List<RestaurantTranslations>? translations;
  final String locale;
  RestaurantDetailConfigModel({this.id, this.name, this.address, this.translations, required this.locale});

  RestaurantDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
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

class PaymentInfoConfigModel {
  String? id;
  String? name;
  String? paymentWay;
  List<PaymentTranslations>? translations;
  final String locale;
  PaymentInfoConfigModel({this.id, this.name, this.paymentWay, this.translations, required this.locale});

  PaymentInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    paymentWay = json['paymentWay'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['paymentWay'] = paymentWay;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
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

class DeliveryAddressRawConfigModel {
  LocationCoordinates? location;
  int? title;
  String? receiverName;
  String? countryCode;
  String? receiverContact;
  String? flatHouse;
  String? locality;
  String? landmark;
  String? id;

  DeliveryAddressRawConfigModel({this.location, this.title, this.receiverName, this.countryCode, this.receiverContact, this.flatHouse, this.locality, this.landmark, this.id});

  DeliveryAddressRawConfigModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? LocationCoordinates.fromJson(json['location']) : null;
    if (json['title'] != null && json['title'] != '') {
      title = int.parse(json['title'].toString());
    } else {
      title = 0;
    }
    receiverName = json['receiverName'];
    countryCode = json['countryCode'].toString();
    receiverContact = json['receiverContact'];
    flatHouse = json['flatHouse'];
    locality = json['locality'];
    landmark = json['landmark'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['title'] = title;
    data['receiverName'] = receiverName;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    data['flatHouse'] = flatHouse;
    data['locality'] = locality;
    data['landmark'] = landmark;
    data['id'] = id;
    return data;
  }
}

class LocationCoordinates {
  String? type;
  List<double>? coordinates;

  LocationCoordinates({this.type, this.coordinates});

  LocationCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class BusinessSettingConfigModel {
  String? companyName;
  String? currencySide;
  String? foodTaxName;
  String? additionalServiceName;
  String? logo;
  String? websiteUrl;
  String? foodLicense;
  String? foodLicenseName;
  String? id;

  BusinessSettingConfigModel({this.companyName, this.currencySide, this.foodTaxName, this.additionalServiceName, this.logo, this.websiteUrl, this.foodLicense, this.foodLicenseName, this.id});

  BusinessSettingConfigModel.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    currencySide = json['currencySide'];
    foodTaxName = json['foodTaxName'];
    additionalServiceName = json['additionalServiceName'];
    logo = json['logo'];
    websiteUrl = json['websiteUrl'];
    foodLicense = json['foodLicense'];
    foodLicenseName = json['foodLicenseName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['currencySide'] = currencySide;
    data['foodTaxName'] = foodTaxName;
    data['additionalServiceName'] = additionalServiceName;
    data['logo'] = logo;
    data['websiteUrl'] = websiteUrl;
    data['foodLicense'] = foodLicense;
    data['foodLicenseName'] = foodLicenseName;
    data['id'] = id;
    return data;
  }
}
