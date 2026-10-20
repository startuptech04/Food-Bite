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

class OrderDetailResponseModel {
  OrderDetailConfigModel? detail;
  OrderSettingConfigModel? orderSettings;
  RestaurantInfoConfigModel? restaurantInfo;
  RestaurantConfigModel? restaurantConfig;
  int? nearDriver;
  DriverConfigConfigModel? driverConfig;
  bool? success;
  final String locale;

  OrderDetailResponseModel({this.detail, this.orderSettings, this.restaurantInfo, this.restaurantConfig, this.nearDriver, this.driverConfig, this.success, required this.locale});

  OrderDetailResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    detail = json['detail'] != null ? OrderDetailConfigModel.fromJson(json['detail'], locale) : null;
    orderSettings = json['orderSettings'] != null ? OrderSettingConfigModel.fromJson(json['orderSettings']) : null;
    restaurantInfo = json['restaurantInfo'] != null ? RestaurantInfoConfigModel.fromJson(json['restaurantInfo']) : null;
    restaurantConfig = json['restaurantConfig'] != null ? RestaurantConfigModel.fromJson(json['restaurantConfig']) : null;
    if (json['nearDriver'] != null && json['nearDriver'] != '') {
      nearDriver = int.parse(json['nearDriver'].toString());
    } else {
      nearDriver = 0;
    }
    driverConfig = json['driverConfig'] != null ? DriverConfigConfigModel.fromJson(json['driverConfig']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    if (orderSettings != null) {
      data['orderSettings'] = orderSettings!.toJson();
    }
    if (restaurantInfo != null) {
      data['restaurantInfo'] = restaurantInfo!.toJson();
    }
    if (restaurantConfig != null) {
      data['restaurantConfig'] = restaurantConfig!.toJson();
    }
    data['nearDriver'] = nearDriver;
    if (driverConfig != null) {
      data['driverConfig'] = driverConfig!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class OrderDetailConfigModel {
  String? paymentMode;
  String? orderTo;
  String? cookingInstruction;
  String? receiverName;
  String? countryCode;
  String? receiverContact;
  bool? instantOrder;
  bool? scheduleOrder;
  String? scheduleDate;
  String? orderAt;
  String? scheduleTime;
  int? userOrderCount;
  String? driverOrderPin;
  String? customerOrderPin;
  String? driverAssign;
  String? status;
  String? createdAt;
  String? id;
  int? orderNo;
  List<FoodInCartModel>? cartItem;
  DeliveryAddressRawConfigModel? deliveryAddressRaw;
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
  int? preparationTime;
  UserInfoConfigModel? userInfo;
  DriverInfoConfigModel? driverInfo;
  PaymentInfoConfigModel? paymentInfo;
  DeliveryInstructionInfoConfigModel? deliveryInstructionInfo;
  final String locale;
  OrderDetailConfigModel({
    this.paymentMode,
    this.orderTo,
    this.cookingInstruction,
    this.receiverName,
    this.countryCode,
    this.receiverContact,
    this.instantOrder,
    this.scheduleOrder,
    this.scheduleDate,
    this.orderAt,
    this.scheduleTime,
    this.userOrderCount,
    this.driverOrderPin,
    this.customerOrderPin,
    this.driverAssign,
    this.status,
    this.createdAt,
    this.id,
    this.orderNo,
    this.cartItem,
    this.deliveryAddressRaw,
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
    this.preparationTime,
    this.userInfo,
    this.driverInfo,
    this.paymentInfo,
    this.deliveryInstructionInfo,
    required this.locale,
  });

  OrderDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    paymentMode = json['paymentMode'];
    orderTo = json['orderTo'];
    cookingInstruction = json['cookingInstruction'];
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
    if (json['orderAt'] != null && json['orderAt'] != '') {
      DateTime parsedTime = DateFormat("h:mm a").parse(json['orderAt'].toString().toUpperCase());
      String formattedTime = DateFormat.jm(locale).format(parsedTime);
      orderAt = formattedTime;
    } else {
      orderAt = '02:00 PM';
    }
    if (json['scheduleTime'] != null && json['scheduleTime'] != '') {
      DateTime parsedTime = DateFormat("h:mm a").parse(json['scheduleTime'].toString().toUpperCase());
      String formattedTime = DateFormat.jm(locale).format(parsedTime);
      scheduleTime = formattedTime;
    } else {
      scheduleTime = '';
    }
    if (json['userOrderCount'] != null && json['userOrderCount'] != '') {
      userOrderCount = int.parse(json['userOrderCount'].toString());
    } else {
      userOrderCount = 0;
    }
    driverOrderPin = json['driverOrderPin'];
    customerOrderPin = json['customerOrderPin'];
    driverAssign = json['driverAssign'];
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'] != '') {
      DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      createdAt = DateFormat.yMMMMd(locale).format(tempDate);
    } else {
      createdAt = '';
    }
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    if (json['cartItem'] != null) {
      cartItem = <FoodInCartModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(FoodInCartModel.fromJson(v, locale));
      });
    }
    deliveryAddressRaw = json['deliveryAddressRaw'] != null ? DeliveryAddressRawConfigModel.fromJson(json['deliveryAddressRaw']) : null;
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
    if (json['preparationTime'] != null && json['preparationTime'] != '') {
      preparationTime = int.parse(json['preparationTime'].toString());
    } else {
      preparationTime = 0;
    }
    userInfo = json['userInfo'] != null ? UserInfoConfigModel.fromJson(json['userInfo']) : null;
    driverInfo = json['driverInfo'] != null ? DriverInfoConfigModel.fromJson(json['driverInfo']) : null;
    paymentInfo = json['paymentInfo'] != null ? PaymentInfoConfigModel.fromJson(json['paymentInfo'], locale) : null;
    deliveryInstructionInfo = json['deliveryInstructionInfo'] != null ? DeliveryInstructionInfoConfigModel.fromJson(json['deliveryInstructionInfo'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentMode'] = paymentMode;
    data['orderTo'] = orderTo;
    data['cookingInstruction'] = cookingInstruction;
    data['receiverName'] = receiverName;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    data['instantOrder'] = instantOrder;
    data['scheduleOrder'] = scheduleOrder;
    data['scheduleDate'] = scheduleDate;
    data['orderAt'] = orderAt;
    data['scheduleTime'] = scheduleTime;
    data['userOrderCount'] = userOrderCount;
    data['driverOrderPin'] = driverOrderPin;
    data['customerOrderPin'] = customerOrderPin;
    data['driverAssign'] = driverAssign;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['orderNo'] = orderNo;
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    if (deliveryAddressRaw != null) {
      data['deliveryAddressRaw'] = deliveryAddressRaw!.toJson();
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
    data['preparationTime'] = preparationTime;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
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

class DriverInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? countryCode;
  String? contactNumber;
  String? contactEmail;
  String? role;

  DriverInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.contactNumber, this.contactEmail, this.role});

  DriverInfoConfigModel.fromJson(Map<String, dynamic> json) {
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

class OrderSettingConfigModel {
  bool? deliveryVerification;
  bool? restaurantCanCancelOrder;
  bool? driverCanCancelOrder;
  String? orderConfirmationModel;
  String? id;

  OrderSettingConfigModel({this.deliveryVerification, this.restaurantCanCancelOrder, this.driverCanCancelOrder, this.orderConfirmationModel, this.id});

  OrderSettingConfigModel.fromJson(Map<String, dynamic> json) {
    deliveryVerification = json['deliveryVerification'];
    restaurantCanCancelOrder = json['restaurantCanCancelOrder'];
    driverCanCancelOrder = json['driverCanCancelOrder'];
    orderConfirmationModel = json['orderConfirmationModel'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliveryVerification'] = deliveryVerification;
    data['restaurantCanCancelOrder'] = restaurantCanCancelOrder;
    data['driverCanCancelOrder'] = driverCanCancelOrder;
    data['orderConfirmationModel'] = orderConfirmationModel;
    data['id'] = id;
    return data;
  }
}

class RestaurantInfoConfigModel {
  LocationCoordinates? location;
  String? name;
  String? logo;
  String? cover;
  bool? ownDriver;
  bool? isOutlet;
  String? outletManagerId;
  String? id;

  RestaurantInfoConfigModel({this.location, this.name, this.logo, this.cover, this.ownDriver, this.isOutlet, this.outletManagerId, this.id});

  RestaurantInfoConfigModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? LocationCoordinates.fromJson(json['location']) : null;
    name = json['name'];
    logo = json['logo'];
    cover = json['cover'];
    ownDriver = json['ownDriver'];
    isOutlet = json['isOutlet'];
    outletManagerId = json['outletManagerId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['name'] = name;
    data['logo'] = logo;
    data['cover'] = cover;
    data['ownDriver'] = ownDriver;
    data['isOutlet'] = isOutlet;
    data['outletManagerId'] = outletManagerId;
    data['id'] = id;
    return data;
  }
}

class RestaurantConfigModel {
  bool? driverPickup;
  bool? canInitiateChat;
  bool? canInitiateCall;
  String? id;

  RestaurantConfigModel({this.driverPickup, this.canInitiateChat, this.canInitiateCall, this.id});

  RestaurantConfigModel.fromJson(Map<String, dynamic> json) {
    driverPickup = json['driverPickup'];
    canInitiateChat = json['canInitiateChat'];
    canInitiateCall = json['canInitiateCall'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverPickup'] = driverPickup;
    data['canInitiateChat'] = canInitiateChat;
    data['canInitiateCall'] = canInitiateCall;
    data['id'] = id;
    return data;
  }
}

class DriverConfigConfigModel {
  int? maxOrderLimit;
  String? id;

  DriverConfigConfigModel({this.maxOrderLimit, this.id});

  DriverConfigConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['maxOrderLimit'] != null && json['maxOrderLimit'] != '') {
      maxOrderLimit = int.parse(json['maxOrderLimit'].toString());
    } else {
      maxOrderLimit = 0;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maxOrderLimit'] = maxOrderLimit;
    data['id'] = id;
    return data;
  }
}
