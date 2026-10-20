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

import 'package:vendor/app/core/models/food_in_cart_model.dart';

class TiffinSubscriptionPurchaseHistoryDetailResponseModel {
  TiffinSubscriptionPurchaseHistoryDetailConfigModel? details;
  SettingConfigModel? settings;
  bool? success;
  final String locale;
  TiffinSubscriptionPurchaseHistoryDetailResponseModel({this.details, this.settings, this.success, required this.locale});

  TiffinSubscriptionPurchaseHistoryDetailResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    details = json['details'] != null ? TiffinSubscriptionPurchaseHistoryDetailConfigModel.fromJson(json['details'], locale) : null;
    settings = json['settings'] != null ? SettingConfigModel.fromJson(json['settings']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class TiffinSubscriptionPurchaseHistoryDetailConfigModel {
  String? slot;
  String? orderAt;
  String? orderTo;
  String? cookingInstruction;
  String? receiverName;
  String? countryCode;
  String? receiverContact;
  int? totalOrder;
  String? startDate;
  List<String>? offDays;
  List<String>? ordersDates;
  List<String>? requestedOffDates;
  String? status;
  String? id;
  List<FoodInCartModel>? cartItem;
  DeliveryAddressConfigModel? deliveryAddress;
  double? itemTotal;
  double? foodServiceCharge;
  double? serviceCharge;
  double? packageCharge;
  double? packageChargeTax;
  double? extraCharge;
  double? grandTotal;
  UserInfoConfigModel? userInfo;
  PackageInfoConfigModel? package;
  PaymentInfoConfigModel? paymentInfo;
  DeliveryInstructionInfoConfigModel? deliveryInstructionInfo;
  final String locale;
  TiffinSubscriptionPurchaseHistoryDetailConfigModel({
    this.slot,
    this.orderAt,
    this.orderTo,
    this.cookingInstruction,
    this.receiverName,
    this.countryCode,
    this.receiverContact,
    this.totalOrder,
    this.startDate,
    this.offDays,
    this.ordersDates,
    this.requestedOffDates,
    this.status,
    this.id,
    this.cartItem,
    this.deliveryAddress,
    this.itemTotal,
    this.foodServiceCharge,
    this.serviceCharge,
    this.packageCharge,
    this.packageChargeTax,
    this.extraCharge,
    this.grandTotal,
    this.userInfo,
    this.package,
    this.paymentInfo,
    this.deliveryInstructionInfo,
    required this.locale,
  });

  TiffinSubscriptionPurchaseHistoryDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    slot = json['slot'];
    orderAt = json['orderAt'];
    orderTo = json['orderTo'];
    cookingInstruction = json['cookingInstruction'];
    receiverName = json['receiverName'];
    countryCode = json['countryCode'].toString();
    receiverContact = json['receiverContact'];
    if (json['totalOrder'] != null && json['totalOrder'] != '') {
      totalOrder = int.parse(json['totalOrder'].toString());
    } else {
      totalOrder = 0;
    }
    startDate = json['startDate'];
    offDays = json['offDays'].cast<String>();
    ordersDates = json['ordersDates'].cast<String>();
    requestedOffDates = json['requestedOffDates'].cast<String>();
    status = json['status'];
    id = json['id'];
    if (json['cartItem'] != null) {
      cartItem = <FoodInCartModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(FoodInCartModel.fromJson(v, locale));
      });
    }
    deliveryAddress = json['deliveryAddress'] != null ? DeliveryAddressConfigModel.fromJson(json['deliveryAddress']) : null;
    if (json['itemTotal'] != null && json['itemTotal'] != '') {
      itemTotal = double.parse(json['itemTotal'].toString());
    } else {
      itemTotal = 0;
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
    userInfo = json['userInfo'] != null ? UserInfoConfigModel.fromJson(json['userInfo']) : null;
    package = json['package'] != null ? PackageInfoConfigModel.fromJson(json['package'], locale) : null;
    paymentInfo = json['paymentInfo'] != null ? PaymentInfoConfigModel.fromJson(json['paymentInfo'], locale) : null;
    deliveryInstructionInfo = json['deliveryInstructionInfo'] != null ? DeliveryInstructionInfoConfigModel.fromJson(json['deliveryInstructionInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slot'] = slot;
    data['orderAt'] = orderAt;
    data['orderTo'] = orderTo;
    data['cookingInstruction'] = cookingInstruction;
    data['receiverName'] = receiverName;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    data['totalOrder'] = totalOrder;
    data['startDate'] = startDate;
    data['offDays'] = offDays;
    data['ordersDates'] = ordersDates;
    data['requestedOffDates'] = requestedOffDates;
    data['status'] = status;
    data['id'] = id;
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    if (deliveryAddress != null) {
      data['deliveryAddress'] = deliveryAddress!.toJson();
    }
    data['itemTotal'] = itemTotal;
    data['foodServiceCharge'] = foodServiceCharge;
    data['serviceCharge'] = serviceCharge;
    data['packageCharge'] = packageCharge;
    data['packageChargeTax'] = packageChargeTax;
    data['extraCharge'] = extraCharge;
    data['grandTotal'] = grandTotal;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    if (package != null) {
      data['package'] = package!.toJson();
    }
    if (paymentInfo != null) {
      data['paymentInfo'] = paymentInfo!.toJson();
    }
    if (deliveryInstructionInfo != null) {
      data['deliveryInstructionInfo'] = deliveryInstructionInfo!.toJson();
    }
    return data;
  }
}

class DeliveryAddressConfigModel {
  LocationCoordinates? location;
  int? title;
  String? receiverName;
  String? countryCode;
  String? receiverContact;
  String? flatHouse;
  String? locality;
  String? distance;
  String? landmark;
  bool? willShow;
  String? id;

  DeliveryAddressConfigModel({this.location, this.title, this.receiverName, this.countryCode, this.receiverContact, this.flatHouse, this.locality, this.distance, this.landmark, this.willShow, this.id});

  DeliveryAddressConfigModel.fromJson(Map<String, dynamic> json) {
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
    distance = json['distance'];
    landmark = json['landmark'];
    willShow = json['willShow'];
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
    data['distance'] = distance;
    data['landmark'] = landmark;
    data['willShow'] = willShow;
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
    if (json['coordinates'] != null && json['coordinates'] is List) {
      coordinates = List<double>.from(json['coordinates'].map((x) => x.toDouble()));
    } else {
      coordinates = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
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

class PackageInfoConfigModel {
  String? id;
  String? name;
  String? shortDescription;
  String? image;
  List<PackageTranslations>? translations;
  final String locale;
  PackageInfoConfigModel({this.id, this.name, this.shortDescription, this.image, this.translations, required this.locale});

  PackageInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    image = json['image'];
    if (json['translations'] != null) {
      translations = <PackageTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(PackageTranslations.fromJson(v));
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['image'] = image;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackageTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  PackageTranslations({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  PackageTranslations.fromJson(Map<String, dynamic> json) {
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

class PaymentInfoConfigModel {
  String? id;
  String? slug;
  String? name;
  String? paymentWay;
  List<PaymentTranslations>? translations;
  final String locale;
  PaymentInfoConfigModel({this.id, this.slug, this.name, this.paymentWay, this.translations, required this.locale});

  PaymentInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    slug = json['slug'];
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
    data['slug'] = slug;
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

class DeliveryInstructionInfoConfigModel {
  String? id;
  String? name;
  String? image;
  List<DeliveryInstructionTranslations>? translations;
  final String locale;
  DeliveryInstructionInfoConfigModel({this.id, this.name, this.image, this.translations, required this.locale});

  DeliveryInstructionInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['translations'] != null) {
      translations = <DeliveryInstructionTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(DeliveryInstructionTranslations.fromJson(v));
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
    data['image'] = image;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryInstructionTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  DeliveryInstructionTranslations({this.name, this.code, this.nativeName, this.value});

  DeliveryInstructionTranslations.fromJson(Map<String, dynamic> json) {
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

class SettingConfigModel {
  bool? canInitiateChat;
  bool? canInitiateCall;
  String? id;

  SettingConfigModel({this.canInitiateChat, this.canInitiateCall, this.id});

  SettingConfigModel.fromJson(Map<String, dynamic> json) {
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
