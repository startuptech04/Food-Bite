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

class NewOrderListModel {
  String? findMode;
  List<OrderModelConfig>? orders;
  OrdersSettingsConfigModel? ordersSettings;
  DriverSettingsConfigModel? driverSettings;
  DriverInfoConfigModel? driverInfo;
  List<DeliveryIncentiveConfigModel>? incentive;
  double? extraShiftChargePercentage;
  bool? success;
  final String locale;

  NewOrderListModel({this.findMode, this.orders, this.ordersSettings, this.driverSettings, this.driverInfo, this.incentive, this.extraShiftChargePercentage, this.success, required this.locale});

  NewOrderListModel.fromJson(Map<String, dynamic> json, this.locale) {
    findMode = json['findMode'];
    if (json['orders'] != null) {
      orders = <OrderModelConfig>[];
      json['orders'].forEach((v) {
        orders!.add(OrderModelConfig.fromJson(v, locale));
      });
    }
    ordersSettings = json['ordersSettings'] != null ? OrdersSettingsConfigModel.fromJson(json['ordersSettings']) : null;
    driverSettings = json['driverSettings'] != null ? DriverSettingsConfigModel.fromJson(json['driverSettings']) : null;
    driverInfo = json['driverInfo'] != null ? DriverInfoConfigModel.fromJson(json['driverInfo']) : null;
    if (json['incentive'] != null) {
      incentive = <DeliveryIncentiveConfigModel>[];
      json['incentive'].forEach((v) {
        incentive!.add(DeliveryIncentiveConfigModel.fromJson(v));
      });
    } else {
      incentive = [];
    }
    if (json['extraShiftChargePercentage'] != null && json['extraShiftChargePercentage'] != '') {
      extraShiftChargePercentage = double.parse(json['extraShiftChargePercentage'].toString());
    } else {
      extraShiftChargePercentage = 0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['findMode'] = findMode;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    if (ordersSettings != null) {
      data['ordersSettings'] = ordersSettings!.toJson();
    }
    if (driverSettings != null) {
      data['driverSettings'] = driverSettings!.toJson();
    }
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
    }
    if (incentive != null) {
      data['incentive'] = incentive!.map((v) => v.toJson()).toList();
    }
    data['extraShiftChargePercentage'] = extraShiftChargePercentage;
    data['success'] = success;
    return data;
  }
}

class OrderModelConfig {
  RestaurantModelConfig? restaurant;
  String? driverOrderStatus;
  String? orderFrom;
  String? createdAt;
  String? orderId;
  String? id;
  int? orderNo;
  DeliveryAddressRawModelConfig? deliveryAddressRaw;
  String? pickupDistance;
  String? dropDistance;
  double? deliveryTip;
  double? grandTotal;
  double? orderEarning;
  double? incentiveAmount;
  double? deliveryTipAmount;
  double? extraEarningOnShift;
  String? restaurantETA;
  final String locale;

  OrderModelConfig({
    this.restaurant,
    this.driverOrderStatus,
    this.orderFrom,
    this.createdAt,
    this.orderId,
    this.id,
    this.orderNo,
    this.deliveryAddressRaw,
    this.pickupDistance,
    this.dropDistance,
    this.deliveryTip,
    this.grandTotal,
    this.orderEarning,
    this.incentiveAmount,
    this.deliveryTipAmount,
    this.extraEarningOnShift,
    this.restaurantETA,
    required this.locale,
  });

  OrderModelConfig.fromJson(Map<String, dynamic> json, this.locale) {
    restaurant = json['restaurant'] != null ? RestaurantModelConfig.fromJson(json['restaurant'], locale) : null;
    driverOrderStatus = json['driverOrderStatus'];
    orderFrom = json['orderFrom'];
    createdAt = json['createdAt'];
    orderId = json['orderId'];
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    deliveryAddressRaw = json['deliveryAddressRaw'] != null ? DeliveryAddressRawModelConfig.fromJson(json['deliveryAddressRaw']) : null;
    if (json['pickupDistance'] != null && json['pickupDistance'] != '') {
      pickupDistance = json['pickupDistance'];
    } else {
      pickupDistance = '0';
    }

    if (json['dropDistance'] != null && json['dropDistance'] != '') {
      dropDistance = json['dropDistance'];
    } else {
      dropDistance = '0';
    }
    if (json['deliveryTip'] != null && json['deliveryTip'] != '') {
      deliveryTip = double.parse(json['deliveryTip'].toString());
    } else {
      deliveryTip = 0;
    }
    if (json['orderEarning'] != null && json['orderEarning'] != '') {
      orderEarning = double.parse(json['orderEarning'].toString());
    } else {
      orderEarning = 0.0;
    }
    if (json['incentiveAmount'] != null && json['incentiveAmount'] != '') {
      incentiveAmount = double.parse(json['incentiveAmount'].toString());
    } else {
      incentiveAmount = 0.0;
    }
    if (json['deliveryTipAmount'] != null && json['deliveryTipAmount'] != '') {
      deliveryTipAmount = double.parse(json['deliveryTipAmount'].toString());
    } else {
      deliveryTipAmount = 0.0;
    }
    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0;
    }
    if (json['extraEarningOnShift'] != null && json['extraEarningOnShift'] != '') {
      extraEarningOnShift = double.parse(json['extraEarningOnShift'].toString());
    } else {
      extraEarningOnShift = 0;
    }
    if (json['restaurantETA'] != null && json['restaurantETA'] != '') {
      restaurantETA = json['restaurantETA'];
    } else {
      restaurantETA = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['driverOrderStatus'] = driverOrderStatus;
    data['orderFrom'] = orderFrom;
    data['createdAt'] = createdAt;
    data['orderId'] = orderId;
    data['id'] = id;
    data['orderNo'] = orderNo;
    if (deliveryAddressRaw != null) {
      data['deliveryAddressRaw'] = deliveryAddressRaw!.toJson();
    }
    data['pickupDistance'] = pickupDistance;
    data['dropDistance'] = dropDistance;
    data['deliveryTip'] = deliveryTip;
    data['orderEarning'] = orderEarning;
    data['incentiveAmount'] = incentiveAmount;
    data['deliveryTipAmount'] = deliveryTipAmount;
    data['extraEarningOnShift'] = extraEarningOnShift;
    data['grandTotal'] = grandTotal;
    data['restaurantETA'] = restaurantETA;
    return data;
  }
}

class RestaurantModelConfig {
  String? id;
  String? name;
  String? logo;
  String? cover;
  String? slug;
  String? address;
  LocationConfigModel? location;
  List<Translations>? translations;
  final String locale;

  RestaurantModelConfig({this.id, this.name, this.logo, this.cover, this.slug, this.address, this.location, this.translations, required this.locale});

  RestaurantModelConfig.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    cover = json['cover'];
    slug = json['slug'];
    address = json['address'];
    location = json['location'] != null ? LocationConfigModel.fromJson(json['location']) : null;
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

class Translations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? address;

  Translations({this.name, this.code, this.nativeName, this.title, this.address});

  Translations.fromJson(Map<String, dynamic> json) {
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

class DeliveryAddressRawModelConfig {
  LocationConfigModel? location;
  int? title;
  String? receiverName;
  int? countryCode;
  String? receiverContact;
  String? flatHouse;
  String? locality;
  String? landmark;
  String? id;

  DeliveryAddressRawModelConfig({this.location, this.title, this.receiverName, this.countryCode, this.receiverContact, this.flatHouse, this.locality, this.landmark, this.id});

  DeliveryAddressRawModelConfig.fromJson(Map<String, dynamic> json) {
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
      countryCode = 91;
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

class OrdersSettingsConfigModel {
  bool? driverCanCancelOrder;
  String? id;

  OrdersSettingsConfigModel({this.driverCanCancelOrder, this.id});

  OrdersSettingsConfigModel.fromJson(Map<String, dynamic> json) {
    driverCanCancelOrder = json['driverCanCancelOrder'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverCanCancelOrder'] = driverCanCancelOrder;
    data['id'] = id;
    return data;
  }
}

class DriverSettingsConfigModel {
  bool? showEarning;
  double? earningAmount;
  double? earningFixedDistanceAmount;
  String? earningModel;
  String? earningOnOrder;
  double? earningSurplusDistanceAmount;
  double? distanceRadiusForFixed;
  bool? haveIncentive;
  String? id;

  DriverSettingsConfigModel({
    this.showEarning,
    this.earningAmount,
    this.earningFixedDistanceAmount,
    this.earningModel,
    this.earningOnOrder,
    this.earningSurplusDistanceAmount,
    this.distanceRadiusForFixed,
    this.haveIncentive,
    this.id,
  });

  DriverSettingsConfigModel.fromJson(Map<String, dynamic> json) {
    showEarning = json['showEarning'];
    if (json['earningAmount'] != null && json['earningAmount'] != '') {
      earningAmount = double.parse(json['earningAmount'].toString());
    } else {
      earningAmount = 0;
    }
    if (json['earningFixedDistanceAmount'] != null && json['earningFixedDistanceAmount'] != '') {
      earningFixedDistanceAmount = double.parse(json['earningFixedDistanceAmount'].toString());
    } else {
      earningFixedDistanceAmount = 0;
    }
    earningModel = json['earningModel'];
    earningOnOrder = json['earningOnOrder'];
    if (json['earningSurplusDistanceAmount'] != null && json['earningSurplusDistanceAmount'] != '') {
      earningSurplusDistanceAmount = double.parse(json['earningSurplusDistanceAmount'].toString());
    } else {
      earningSurplusDistanceAmount = 0;
    }
    if (json['distanceRadiusForFixed'] != null && json['distanceRadiusForFixed'] != '') {
      distanceRadiusForFixed = double.parse(json['distanceRadiusForFixed'].toString());
    } else {
      distanceRadiusForFixed = 0;
    }
    haveIncentive = json['haveIncentive'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['showEarning'] = showEarning;
    data['earningAmount'] = earningAmount;
    data['earningFixedDistanceAmount'] = earningFixedDistanceAmount;
    data['earningModel'] = earningModel;
    data['earningOnOrder'] = earningOnOrder;
    data['earningSurplusDistanceAmount'] = earningSurplusDistanceAmount;
    data['distanceRadiusForFixed'] = distanceRadiusForFixed;
    data['haveIncentive'] = haveIncentive;
    data['id'] = id;
    return data;
  }
}

class DriverInfoConfigModel {
  String? type;
  String? id;

  DriverInfoConfigModel({this.type, this.id});

  DriverInfoConfigModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    return data;
  }
}

class DeliveryIncentiveConfigModel {
  double? orderTotal;
  double? incentiveAmount;
  bool? status;
  String? id;

  DeliveryIncentiveConfigModel({this.orderTotal, this.incentiveAmount, this.status, this.id});

  DeliveryIncentiveConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['orderTotal'] != null && json['orderTotal'] != '') {
      orderTotal = double.parse(json['orderTotal'].toString());
    } else {
      orderTotal = 0;
    }
    if (json['incentiveAmount'] != null && json['incentiveAmount'] != '') {
      incentiveAmount = double.parse(json['incentiveAmount'].toString());
    } else {
      incentiveAmount = 0;
    }
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderTotal'] = orderTotal;
    data['incentiveAmount'] = incentiveAmount;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
