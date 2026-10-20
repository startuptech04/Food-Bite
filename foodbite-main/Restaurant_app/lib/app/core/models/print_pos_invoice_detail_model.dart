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

class PrintPOSInvoiceDetailModel {
  OrderDetailConfigModel? details;
  BusinessSettingConfigModel? businessSettings;
  bool? success;
  final String locale;
  PrintPOSInvoiceDetailModel({this.details, this.businessSettings, this.success, required this.locale});

  PrintPOSInvoiceDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
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
  RestaurantDetailConfigModel? restaurant;
  String? paymentMode;
  String? customerType;
  String? customerName;
  String? customerCountryCode;
  String? customerMobileNumber;
  String? discountType;
  String? orderFrom;
  String? createdAt;
  String? id;
  double? discountAmount;
  double? realTotal;
  double? itemTotal;
  double? itemDiscount;
  double? discountCharge;
  double? foodServiceCharge;
  double? serviceCharge;
  double? packageCharge;
  double? packageChargeTax;
  double? waiterTip;
  double? extraCharge;
  double? grandTotal;
  List<FoodInCartModel>? cartItem;
  final String locale;
  OrderDetailConfigModel({
    this.orderNo,
    this.restaurant,
    this.paymentMode,
    this.customerType,
    this.customerName,
    this.customerCountryCode,
    this.customerMobileNumber,
    this.discountType,
    this.orderFrom,
    this.createdAt,
    this.id,
    this.discountAmount,
    this.realTotal,
    this.itemTotal,
    this.itemDiscount,
    this.discountCharge,
    this.foodServiceCharge,
    this.serviceCharge,
    this.packageCharge,
    this.packageChargeTax,
    this.waiterTip,
    this.extraCharge,
    this.grandTotal,
    this.cartItem,
    required this.locale,
  });

  OrderDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    restaurant = json['restaurant'] != null ? RestaurantDetailConfigModel.fromJson(json['restaurant'], locale) : null;
    paymentMode = json['paymentMode'];
    customerType = json['customerType'];
    customerName = json['customerName'];
    if (json['customerCountryCode'] != null && json['customerCountryCode'] != '') {
      customerCountryCode = json['customerCountryCode'].toString();
    } else {
      customerCountryCode = '';
    }
    customerMobileNumber = json['customerMobileNumber'];
    discountType = json['discountType'];
    orderFrom = json['orderFrom'];
    if (json['createdAt'] != null && json['createdAt'] != '') {
      DateTime utcDate = DateTime.parse(json['createdAt']);
      DateTime localDate = utcDate.toLocal();
      createdAt = DateFormat('yyyy-MM-dd hh:mm a', locale).format(localDate);
    } else {
      createdAt = '';
    }
    id = json['id'];
    if (json['discountAmount'] != null && json['discountAmount'] != '') {
      discountAmount = double.parse(json['discountAmount'].toString());
    } else {
      discountAmount = 0;
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
    if (json['discountCharge'] != null && json['discountCharge'] != '') {
      discountCharge = double.parse(json['discountCharge'].toString());
    } else {
      discountCharge = 0;
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
    if (json['waiterTip'] != null && json['waiterTip'] != '') {
      waiterTip = double.parse(json['waiterTip'].toString());
    } else {
      waiterTip = 0;
    }
    if (json['extraCharge'] != null && json['extraCharge'] != '') {
      extraCharge = double.parse(json['extraCharge'].toString());
    } else {
      extraCharge = 0;
    }
    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0;
    }
    if (json['cartItem'] != null) {
      cartItem = <FoodInCartModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(FoodInCartModel.fromJson(v, locale));
      });
    } else {
      cartItem = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderNo'] = orderNo;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['paymentMode'] = paymentMode;
    data['customerType'] = customerType;
    data['customerName'] = customerName;
    data['customerCountryCode'] = customerCountryCode;
    data['customerMobileNumber'] = customerMobileNumber;
    data['discountType'] = discountType;
    data['orderFrom'] = orderFrom;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['discountAmount'] = discountAmount;
    data['realTotal'] = realTotal;
    data['itemTotal'] = itemTotal;
    data['itemDiscount'] = itemDiscount;
    data['discountCharge'] = discountCharge;
    data['foodServiceCharge'] = foodServiceCharge;
    data['serviceCharge'] = serviceCharge;
    data['packageCharge'] = packageCharge;
    data['packageChargeTax'] = packageChargeTax;
    data['waiterTip'] = waiterTip;
    data['extraCharge'] = extraCharge;
    data['grandTotal'] = grandTotal;
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
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
