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

class OrderListResponseModel {
  List<OrderListDetailConfigModel>? orders;
  int? totalPages;
  int? totalResults;
  int? page;
  int? limit;
  String? findMode;
  bool? success;
  final String locale;

  OrderListResponseModel({this.orders, this.totalPages, this.totalResults, this.page, this.limit, this.findMode, this.success, required this.locale});

  OrderListResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orders'] != null) {
      orders = <OrderListDetailConfigModel>[];
      json['orders'].forEach((v) {
        orders!.add(OrderListDetailConfigModel.fromJson(v, locale));
      });
    }
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
    page = json['page'];
    limit = json['limit'];
    findMode = json['findMode'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['page'] = page;
    data['limit'] = limit;
    data['findMode'] = findMode;
    data['success'] = success;
    return data;
  }
}

class OrderListDetailConfigModel {
  OrderRestaurantInfoModel? restaurant;
  String? driverOrderStatus;
  String? statusName;
  String? createdAt;
  String? id;
  double? earning;
  double? tipAmount;
  double? incentiveAmount;
  OrderInfoConfigModel? order;
  double? distance;
  DeliveryAddressRawModelConfig? deliveryAddressRaw;
  String? deliveryFullAddress;
  final String locale;
  OrderListDetailConfigModel({
    this.restaurant,
    this.driverOrderStatus,
    this.statusName,
    this.createdAt,
    this.id,
    this.earning,
    this.tipAmount,
    this.incentiveAmount,
    this.order,
    this.distance,
    this.deliveryAddressRaw,
    this.deliveryFullAddress,
    required this.locale,
  });

  OrderListDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    restaurant = json['restaurant'] != null ? OrderRestaurantInfoModel.fromJson(json['restaurant'], locale) : null;
    driverOrderStatus = json['driverOrderStatus'];

    if (json['driverOrderStatus'] != null && json['driverOrderStatus'] != '') {
      statusName = json['driverOrderStatus'];
    } else {
      statusName = 'New Order';
    }
    if (json['createdAt'] != null && json['createdAt'] != '') {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '15 July 1997';
    }
    id = json['id'];
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
    if (json['distance'] != null && json['distance'] != '') {
      distance = double.parse(json['distance'].toString());
    } else {
      distance = 0;
    }
    order = json['order'] != null ? OrderInfoConfigModel.fromJson(json['order']) : null;
    deliveryAddressRaw = json['deliveryAddressRaw'] != null ? DeliveryAddressRawModelConfig.fromJson(json['deliveryAddressRaw']) : null;
    if (json['deliveryFullAddress'] != null && json['deliveryFullAddress'] != '') {
      deliveryFullAddress = json['deliveryFullAddress'];
    } else {
      deliveryFullAddress = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['driverOrderStatus'] = driverOrderStatus;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['earning'] = earning;
    data['tipAmount'] = tipAmount;
    data['incentiveAmount'] = incentiveAmount;
    data['distance'] = distance;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (deliveryAddressRaw != null) {
      data['deliveryAddressRaw'] = deliveryAddressRaw!.toJson();
    }
    data['deliveryFullAddress'] = deliveryFullAddress;
    return data;
  }
}

class OrderInfoConfigModel {
  String? id;
  int? orderNo;
  String? receiverName;
  OrderInfoConfigModel({this.id, this.orderNo, this.receiverName});

  OrderInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    receiverName = json['receiverName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderNo'] = orderNo;
    data['receiverName'] = receiverName;
    return data;
  }
}

class OrderRestaurantInfoModel {
  String? id;
  String? name;
  String? logo;
  String? cover;
  String? slug;
  String? address;
  LocationConfigModel? location;
  List<RestaurantTranslations>? translations;
  final String locale;

  OrderRestaurantInfoModel({this.id, this.name, this.logo, this.cover, this.slug, this.address, this.location, this.translations, required this.locale});

  OrderRestaurantInfoModel.fromJson(Map<String, dynamic> json, this.locale) {
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
