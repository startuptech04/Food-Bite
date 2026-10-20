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

class OrderListModel {
  List<OrdersConfigModel>? orders;
  int? newOrders;
  int? preparingOrders;
  int? readyOrder;
  int? handOverOrder;
  int? ongoingOrder;
  int? deliveredOrder;
  int? rejectedOrder;
  OrderSettings? orderSettings;
  int? totalPages;
  int? totalResults;
  int? page;
  int? limit;
  RestaurantInfo? restaurantInfo;
  RestaurantConfigModel? restaurantConfig;
  DriverSettingConfig? driverSettingConfig;
  int? nearDriver;
  bool? success;
  final String locale;
  OrderListModel({
    this.orders,
    this.newOrders,
    this.preparingOrders,
    this.readyOrder,
    this.handOverOrder,
    this.ongoingOrder,
    this.deliveredOrder,
    this.rejectedOrder,
    this.orderSettings,
    this.totalPages,
    this.totalResults,
    this.page,
    this.limit,
    this.restaurantInfo,
    this.restaurantConfig,
    this.driverSettingConfig,
    this.nearDriver,
    this.success,
    required this.locale,
  });

  OrderListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orders'] != null) {
      orders = <OrdersConfigModel>[];
      json['orders'].forEach((v) {
        orders!.add(OrdersConfigModel.fromJson(v, locale));
      });
    }
    if (json['newOrders'] != null && json['newOrders'] != '') {
      newOrders = int.parse(json['newOrders'].toString());
    } else {
      newOrders = 0;
    }
    if (json['preparingOrders'] != null && json['preparingOrders'] != '') {
      preparingOrders = int.parse(json['preparingOrders'].toString());
    } else {
      preparingOrders = 0;
    }
    if (json['readyOrder'] != null && json['readyOrder'] != '') {
      readyOrder = int.parse(json['readyOrder'].toString());
    } else {
      readyOrder = 0;
    }
    if (json['handOverOrder'] != null && json['handOverOrder'] != '') {
      handOverOrder = int.parse(json['handOverOrder'].toString());
    } else {
      handOverOrder = 0;
    }
    if (json['ongoingOrder'] != null && json['ongoingOrder'] != '') {
      ongoingOrder = int.parse(json['ongoingOrder'].toString());
    } else {
      ongoingOrder = 0;
    }
    if (json['deliveredOrder'] != null && json['deliveredOrder'] != '') {
      deliveredOrder = int.parse(json['deliveredOrder'].toString());
    } else {
      deliveredOrder = 0;
    }
    if (json['rejectedOrder'] != null && json['rejectedOrder'] != '') {
      rejectedOrder = int.parse(json['rejectedOrder'].toString());
    } else {
      rejectedOrder = 0;
    }
    orderSettings = json['orderSettings'] != null ? OrderSettings.fromJson(json['orderSettings']) : null;
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
    restaurantInfo = json['restaurantInfo'] != null ? RestaurantInfo.fromJson(json['restaurantInfo']) : null;
    restaurantConfig = json['restaurantConfig'] != null ? RestaurantConfigModel.fromJson(json['restaurantConfig']) : null;
    driverSettingConfig = json['driverConfig'] != null ? DriverSettingConfig.fromJson(json['driverConfig']) : null;
    if (json['nearDriver'] != null && json['nearDriver'] != '') {
      nearDriver = int.parse(json['nearDriver'].toString());
    } else {
      nearDriver = 0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['newOrders'] = newOrders;
    data['preparingOrders'] = preparingOrders;
    data['readyOrder'] = readyOrder;
    data['handOverOrder'] = handOverOrder;
    data['ongoingOrder'] = ongoingOrder;
    data['deliveredOrder'] = deliveredOrder;
    data['rejectedOrder'] = rejectedOrder;
    if (orderSettings != null) {
      data['orderSettings'] = orderSettings!.toJson();
    }
    data['totalPages'] = totalPages;
    data['page'] = page;
    data['limit'] = limit;
    if (restaurantInfo != null) {
      data['restaurantInfo'] = restaurantInfo!.toJson();
    }
    if (restaurantConfig != null) {
      data['restaurantConfig'] = restaurantConfig!.toJson();
    }
    if (driverSettingConfig != null) {
      data['driverConfig'] = driverSettingConfig!.toJson();
    }
    data['nearDriver'] = nearDriver;
    data['success'] = success;
    return data;
  }
}

class OrdersConfigModel {
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
  int? preparationTime;
  String? status;
  String? statusName;
  String? createdAt;
  String? id;
  int? orderNo;
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
  String? userOrderCount;
  UserInfo? userInfo;
  DriverInfo? driverInfo;
  String? driverAssign;
  String? customerOrderPin;
  String? driverOrderPin;
  PaymentInfoConfigModel? paymentInfo;
  final String locale;
  OrdersConfigModel({
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
    this.preparationTime,
    this.status,
    this.statusName,
    this.createdAt,
    this.id,
    this.orderNo,
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
    this.userOrderCount,
    this.userInfo,
    this.driverInfo,
    this.driverAssign,
    this.customerOrderPin,
    this.driverOrderPin,
    this.paymentInfo,
    required this.locale,
  });

  OrdersConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
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
    if (json['scheduleTime'] != null && json['scheduleTime'] != '') {
      DateTime parsedTime = DateFormat("h:mm a").parse(json['scheduleTime'].toString().toUpperCase());
      String formattedTime = DateFormat.jm(locale).format(parsedTime);
      scheduleTime = formattedTime;
    } else {
      scheduleTime = '';
    }
    if (json['orderAt'] != null && json['orderAt'] != '') {
      DateTime parsedTime = DateFormat("h:mm a").parse(json['orderAt'].toString().toUpperCase());
      String formattedTime = DateFormat.jm(locale).format(parsedTime);
      orderAt = formattedTime;
    } else {
      orderAt = '02:00 PM';
    }
    if (json['preparationTime'] != null && json['preparationTime'] != '') {
      preparationTime = int.parse(json['preparationTime'].toString());
    } else {
      preparationTime = 10;
    }
    String titleize(String slug) {
      List<String> words = slug.split('_');
      for (int i = 0; i < words.length; i++) {
        words[i] = '${words[i][0].toUpperCase()}${words[i].substring(1)}';
      }
      return words.join(' ');
    }

    if (json['status'] != null && json['status'] != '') {
      statusName = titleize(json['status']);
      status = json['status'];
    } else {
      status = 'created';
      statusName = 'Created';
    }
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
    if (json['userOrderCount'] != null && json['userOrderCount'] != '') {
      String addOrdinalSuffix(int number) {
        if (number % 100 >= 11 && number % 100 <= 13) {
          return '$number'
              'th';
        }
        switch (number % 10) {
          case 1:
            return '$number'
                'st';
          case 2:
            return '$number'
                'nd';
          case 3:
            return '$number'
                'rd';
          default:
            return '$number'
                'th';
        }
      }

      userOrderCount = addOrdinalSuffix(int.parse(json['userOrderCount'].toString()));
    } else {
      userOrderCount = '1st';
    }
    userInfo = json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
    driverInfo = json['driverInfo'] != null ? DriverInfo.fromJson(json['driverInfo']) : null;
    paymentInfo = json['paymentInfo'] != null ? PaymentInfoConfigModel.fromJson(json['paymentInfo'], locale) : null;
    if (json['driverAssign'] != null && json['driverAssign'] != '') {
      driverAssign = json['driverAssign'];
    } else {
      driverAssign = 'ideal';
    }
    customerOrderPin = json['customerOrderPin'];
    driverOrderPin = json['driverOrderPin'];
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
    data['preparationTime'] = preparationTime;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['orderNo'] = orderNo;
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
    data['driverAssign'] = driverAssign;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
    }
    if (paymentInfo != null) {
      data['paymentInfo'] = paymentInfo!.toJson();
    }
    data['customerOrderPin'] = customerOrderPin;
    data['driverOrderPin'] = driverOrderPin;
    return data;
  }
}

class RestaurantInfo {
  LocationCoordinates? location;
  String? name;
  String? logo;
  String? cover;
  String? id;
  bool? status;
  bool? temporaryClosed;

  RestaurantInfo({this.location, this.name, this.logo, this.cover, this.id, this.status, this.temporaryClosed});

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? LocationCoordinates.fromJson(json['location']) : null;
    name = json['name'];
    logo = json['logo'];
    cover = json['cover'];
    id = json['id'];
    status = json['status'];
    temporaryClosed = json['temporaryClosed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['name'] = name;
    data['logo'] = logo;
    data['cover'] = cover;
    data['id'] = id;
    data['status'] = status;
    data['temporaryClosed'] = temporaryClosed;
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

class UserInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? image;

  UserInfo({this.id, this.firstName, this.lastName, this.image});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    return data;
  }
}

class DriverInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? image;

  DriverInfo({this.id, this.firstName, this.lastName, this.image});

  DriverInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    return data;
  }
}

class OrderSettings {
  bool? restaurantCanCancelOrder;
  bool? driverCanCancelOrder;
  bool? deliveryVerification;
  String? orderConfirmationModel;
  String? id;

  OrderSettings({this.restaurantCanCancelOrder, this.driverCanCancelOrder, this.deliveryVerification, this.orderConfirmationModel, this.id});

  OrderSettings.fromJson(Map<String, dynamic> json) {
    restaurantCanCancelOrder = json['restaurantCanCancelOrder'];
    driverCanCancelOrder = json['driverCanCancelOrder'];
    deliveryVerification = json['deliveryVerification'];
    orderConfirmationModel = json['orderConfirmationModel'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurantCanCancelOrder'] = restaurantCanCancelOrder;
    data['driverCanCancelOrder'] = driverCanCancelOrder;
    data['deliveryVerification'] = deliveryVerification;
    data['orderConfirmationModel'] = orderConfirmationModel;
    data['id'] = id;
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

class DriverSettingConfig {
  int? maxOrderLimit;
  String? id;

  DriverSettingConfig({this.maxOrderLimit, this.id});

  DriverSettingConfig.fromJson(Map<String, dynamic> json) {
    if (json['maxOrderLimit'] != null && json['maxOrderLimit'] != '') {
      maxOrderLimit = int.parse(json['maxOrderLimit'].toString());
    } else {
      maxOrderLimit = 1;
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
