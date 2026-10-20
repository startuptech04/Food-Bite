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

import 'package:driver/app/core/models/food_in_cart_model.dart';

class OrderDetailResponseModel {
  OrderDetailConfigModel? details;
  String? findMode;
  DriverSettingsConfigModel? driverSettings;
  OrderSettingsConfigModel? orderSettings;
  bool? success;
  final String locale;

  OrderDetailResponseModel({this.details, this.findMode, this.driverSettings, this.orderSettings, this.success, required this.locale});

  OrderDetailResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    details = json['details'] != null ? OrderDetailConfigModel.fromJson(json['details'], locale) : null;
    findMode = json['findMode'];
    driverSettings = json['driverSettings'] != null ? DriverSettingsConfigModel.fromJson(json['driverSettings']) : null;
    orderSettings = json['orderSettings'] != null ? OrderSettingsConfigModel.fromJson(json['orderSettings']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['findMode'] = findMode;
    if (driverSettings != null) {
      data['driverSettings'] = driverSettings!.toJson();
    }
    if (orderSettings != null) {
      data['orderSettings'] = orderSettings!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class OrderDetailConfigModel {
  String? user;
  RestaurantConfigModel? restaurant;
  String? receiverName;
  int? countryCode;
  String? receiverContact;
  String? driverOrderPin;
  String? customerOrderPin;
  String? status;
  String? id;
  int? orderNo;
  DeliveryAddressRawConfigModel? deliveryAddressRaw;
  List<FoodInCartModel>? cartItem;
  double? grandTotal;
  double? itemTotal;
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
  DeliveryInstructionInfoConfigModel? deliveryInstructionInfo;
  OrderEarningBreakdownModel? orderExtraDetail;
  String? deliveryFullAddress;
  final String locale;

  OrderDetailConfigModel({
    this.user,
    this.restaurant,
    this.receiverName,
    this.countryCode,
    this.receiverContact,
    this.driverOrderPin,
    this.customerOrderPin,
    this.status,
    this.id,
    this.orderNo,
    this.deliveryAddressRaw,
    this.cartItem,
    this.grandTotal,
    this.itemTotal,
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
    this.deliveryInstructionInfo,
    this.orderExtraDetail,
    this.deliveryFullAddress,
    required this.locale,
  });

  OrderDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['user'] != null && json['user'] != '') {
      user = json['user'];
    } else {
      user = '';
    }
    restaurant = json['restaurant'] != null ? RestaurantConfigModel.fromJson(json['restaurant'], locale) : null;
    receiverName = json['receiverName'];
    countryCode = json['countryCode'];
    receiverContact = json['receiverContact'];
    driverOrderPin = json['driverOrderPin'];
    customerOrderPin = json['customerOrderPin'];
    status = json['status'];
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    deliveryAddressRaw = json['deliveryAddressRaw'] != null ? DeliveryAddressRawConfigModel.fromJson(json['deliveryAddressRaw']) : null;
    if (json['cartItem'] != null) {
      cartItem = <FoodInCartModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(FoodInCartModel.fromJson(v, locale));
      });
    }
    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0.0;
    }
    if (json['itemTotal'] != null && json['itemTotal'] != '') {
      itemTotal = double.parse(json['itemTotal'].toString());
    } else {
      itemTotal = 0.0;
    }
    if (json['couponDiscountCharge'] != null && json['couponDiscountCharge'] != '') {
      couponDiscountCharge = double.parse(json['couponDiscountCharge'].toString());
    } else {
      couponDiscountCharge = 0.0;
    }
    if (json['deliveryCharge'] != null && json['deliveryCharge'] != '') {
      deliveryCharge = double.parse(json['deliveryCharge'].toString());
    } else {
      deliveryCharge = 0.0;
    }
    if (json['foodServiceCharge'] != null && json['foodServiceCharge'] != '') {
      foodServiceCharge = double.parse(json['foodServiceCharge'].toString());
    } else {
      foodServiceCharge = 0.0;
    }
    if (json['serviceCharge'] != null && json['serviceCharge'] != '') {
      serviceCharge = double.parse(json['serviceCharge'].toString());
    } else {
      serviceCharge = 0.0;
    }
    if (json['packageCharge'] != null && json['packageCharge'] != '') {
      packageCharge = double.parse(json['packageCharge'].toString());
    } else {
      packageCharge = 0.0;
    }
    if (json['packageChargeTax'] != null && json['packageChargeTax'] != '') {
      packageChargeTax = double.parse(json['packageChargeTax'].toString());
    } else {
      packageChargeTax = 0.0;
    }
    if (json['walletAmount'] != null && json['walletAmount'] != '') {
      walletAmount = double.parse(json['walletAmount'].toString());
    } else {
      walletAmount = 0.0;
    }
    if (json['deliveryTip'] != null && json['deliveryTip'] != '') {
      deliveryTip = double.parse(json['deliveryTip'].toString());
    } else {
      deliveryTip = 0.0;
    }
    if (json['extraCharge'] != null && json['extraCharge'] != '') {
      extraCharge = double.parse(json['extraCharge'].toString());
    } else {
      extraCharge = 0.0;
    }
    if (json['deliveryFullAddress'] != null && json['deliveryFullAddress'] != '') {
      deliveryFullAddress = json['deliveryFullAddress'];
    } else {
      deliveryFullAddress = '';
    }
    paymentInfo = json['paymentInfo'] != null ? PaymentInfoConfigModel.fromJson(json['paymentInfo'], locale) : null;
    deliveryInstructionInfo = json['deliveryInstructionInfo'] != null ? DeliveryInstructionInfoConfigModel.fromJson(json['deliveryInstructionInfo'], locale) : null;
    orderExtraDetail = json['orderExtraDetail'] != null ? OrderEarningBreakdownModel.fromJson(json['orderExtraDetail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['receiverName'] = receiverName;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    data['driverOrderPin'] = driverOrderPin;
    data['customerOrderPin'] = customerOrderPin;
    data['status'] = status;
    data['id'] = id;
    data['orderNo'] = orderNo;
    if (deliveryAddressRaw != null) {
      data['deliveryAddressRaw'] = deliveryAddressRaw!.toJson();
    }
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    data['grandTotal'] = grandTotal;
    data['itemTotal'] = itemTotal;
    data['couponDiscountCharge'] = couponDiscountCharge;
    data['deliveryCharge'] = deliveryCharge;
    data['foodServiceCharge'] = foodServiceCharge;
    data['serviceCharge'] = serviceCharge;
    data['packageCharge'] = packageCharge;
    data['packageChargeTax'] = packageChargeTax;
    data['walletAmount'] = walletAmount;
    data['deliveryTip'] = deliveryTip;
    data['extraCharge'] = extraCharge;
    data['deliveryFullAddress'] = deliveryFullAddress;
    if (paymentInfo != null) {
      data['paymentInfo'] = paymentInfo!.toJson();
    }
    if (deliveryInstructionInfo != null) {
      data['deliveryInstructionInfo'] = deliveryInstructionInfo!.toJson();
    }
    if (orderExtraDetail != null) {
      data['orderExtraDetail'] = orderExtraDetail!.toJson();
    }
    return data;
  }
}

class RestaurantConfigModel {
  String? id;
  String? name;
  String? logo;
  String? cover;
  String? slug;
  String? address;
  LocationConfigModel? location;
  List<RestaurantTranslations>? translations;
  final String locale;

  RestaurantConfigModel({this.id, this.name, this.logo, this.cover, this.slug, this.address, this.location, this.translations, required this.locale});

  RestaurantConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    cover = json['cover'];
    slug = json['slug'];
    address = json['address'];
    location = json['location'] != null ? LocationConfigModel.fromJson(json['location']) : null;
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
    data['logo'] = logo;
    data['cover'] = cover;
    data['slug'] = slug;
    data['address'] = address;
    if (location != null) {
      data['location'] = location!.toJson();
    }
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

  RestaurantTranslations({this.name, this.code, this.nativeName, this.title, this.address});

  RestaurantTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    data['address'] = address;
    return data;
  }
}

class LocationConfigModel {
  String? type;
  List<double>? coordinates;

  LocationConfigModel({this.type, this.coordinates});

  LocationConfigModel.fromJson(Map<String, dynamic> json) {
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

class DeliveryAddressRawConfigModel {
  LocationConfigModel? location;
  int? title;
  String? receiverName;
  int? countryCode;
  String? receiverContact;
  String? flatHouse;
  String? locality;
  String? landmark;
  String? id;

  DeliveryAddressRawConfigModel({this.location, this.title, this.receiverName, this.countryCode, this.receiverContact, this.flatHouse, this.locality, this.landmark, this.id});

  DeliveryAddressRawConfigModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? LocationConfigModel.fromJson(json['location']) : null;
    if (json['title'] != null && json['title'] != '') {
      title = int.parse(json['title'].toString());
    } else {
      title = 0;
    }
    receiverName = json['receiverName'];
    if (json['countryCode'] != null && json['countryCode'] != '') {
      countryCode = int.parse(json['countryCode'].toString());
    } else {
      countryCode = 0;
    }
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

class RestaurantInfoModel {
  String? id;
  String? name;
  String? logo;
  String? cover;
  List<RestaurantTranslations>? translations;
  final String locale;

  RestaurantInfoModel({this.id, this.name, this.logo, this.cover, this.translations, required this.locale});

  RestaurantInfoModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
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
    data['logo'] = logo;
    data['cover'] = cover;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
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

class DriverSettingsConfigModel {
  bool? deliveryProof;
  bool? canInitiateChat;
  bool? canInitiateCall;
  bool? pickupProof;
  String? id;

  DriverSettingsConfigModel({this.deliveryProof, this.canInitiateChat, this.canInitiateCall, this.pickupProof, this.id});

  DriverSettingsConfigModel.fromJson(Map<String, dynamic> json) {
    deliveryProof = json['deliveryProof'];
    canInitiateChat = json['canInitiateChat'];
    canInitiateCall = json['canInitiateCall'];
    pickupProof = json['pickupProof'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliveryProof'] = deliveryProof;
    data['canInitiateChat'] = canInitiateChat;
    data['canInitiateCall'] = canInitiateCall;
    data['pickupProof'] = pickupProof;
    data['id'] = id;
    return data;
  }
}

class OrderSettingsConfigModel {
  bool? deliveryVerification;
  bool? driverCanCancelOrder;
  String? orderConfirmationModel;
  String? id;

  OrderSettingsConfigModel({this.deliveryVerification, this.driverCanCancelOrder, this.orderConfirmationModel, this.id});

  OrderSettingsConfigModel.fromJson(Map<String, dynamic> json) {
    deliveryVerification = json['deliveryVerification'];
    driverCanCancelOrder = json['driverCanCancelOrder'];
    orderConfirmationModel = json['orderConfirmationModel'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliveryVerification'] = deliveryVerification;
    data['driverCanCancelOrder'] = driverCanCancelOrder;
    data['orderConfirmationModel'] = orderConfirmationModel;
    data['id'] = id;
    return data;
  }
}

class OrderEarningBreakdownModel {
  double? earning;
  double? tipAmount;
  double? incentiveAmount;

  OrderEarningBreakdownModel({this.earning, this.tipAmount, this.incentiveAmount});

  OrderEarningBreakdownModel.fromJson(Map<String, dynamic> json) {
    if (json['earning'] != null && json['earning'] != '') {
      earning = double.parse(json['earning'].toString());
    } else {
      earning = 0;
    }
    if (json['tipAmount'] != null && json['tipAmount'] != '') {
      tipAmount = double.parse(json['tipAmount'].toString());
    } else {
      tipAmount = 0;
    }
    if (json['incentiveAmount'] != null && json['incentiveAmount'] != '') {
      incentiveAmount = double.parse(json['incentiveAmount'].toString());
    } else {
      incentiveAmount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['earning'] = earning;
    data['tipAmount'] = tipAmount;
    data['incentiveAmount'] = incentiveAmount;
    return data;
  }
}
