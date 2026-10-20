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

class NearMeTrendingRestaurantsModel {
  List<RestaurantConfigModel>? restaurants;
  String? findMode;
  double? radius;
  DriverMetaConfigModel? driverMeta;
  DriverInfoConfigModel? driverInfo;
  List<ActiveOrdersConfigModel>? orders;
  bool? success;
  final String locale;

  NearMeTrendingRestaurantsModel({this.restaurants, this.findMode, this.radius, this.driverMeta, this.driverInfo, this.orders, this.success, required this.locale});

  NearMeTrendingRestaurantsModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['restaurants'] != null) {
      restaurants = <RestaurantConfigModel>[];
      json['restaurants'].forEach((v) {
        restaurants!.add(RestaurantConfigModel.fromJson(v, locale));
      });
    }
    findMode = json['findMode'];
    if (json['radius'] != null && json['radius'] != '') {
      radius = double.parse(json['radius'].toString());
    } else {
      radius = 20;
    }
    driverMeta = json['driverMeta'] != null ? DriverMetaConfigModel.fromJson(json['driverMeta']) : null;
    driverInfo = json['driverInfo'] != null ? DriverInfoConfigModel.fromJson(json['driverInfo']) : null;
    if (json['orders'] != null) {
      orders = <ActiveOrdersConfigModel>[];
      json['orders'].forEach((v) {
        orders!.add(ActiveOrdersConfigModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurants != null) {
      data['restaurants'] = restaurants!.map((v) => v.toJson()).toList();
    }
    data['findMode'] = findMode;
    data['radius'] = radius;
    if (driverMeta != null) {
      data['driverMeta'] = driverMeta!.toJson();
    }
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
    }
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class RestaurantConfigModel {
  String? name;
  String? address;
  String? logo;
  String? cover;
  LocationCoordinatesModel? location;
  List<Translations>? translations;
  bool? status;
  String? slug;
  String? distance;
  String? id;
  int? orders;
  final String locale;

  RestaurantConfigModel({this.name, this.address, this.logo, this.cover, this.location, this.translations, this.status, this.slug, this.distance, this.id, this.orders, required this.locale});

  RestaurantConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    address = json['address'];
    logo = json['logo'];
    cover = json['cover'];
    location = json['location'] != null ? LocationCoordinatesModel.fromJson(json['location']) : null;
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
    status = json['status'];
    slug = json['slug'];
    if (json['distance'] != null && json['distance'] != '') {
      distance = double.parse(json['distance'].toString()).toStringAsFixed(1);
    } else {
      distance = '0.0';
    }
    id = json['id'];
    if (json['orders'] != null && json['orders'] != '') {
      orders = int.parse(json['orders'].toString());
    } else {
      orders = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['logo'] = logo;
    data['cover'] = cover;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['slug'] = slug;
    data['distance'] = distance;
    data['id'] = id;
    data['orders'] = orders;
    return data;
  }
}

class LocationCoordinatesModel {
  String? type;
  List<double>? coordinates;

  LocationCoordinatesModel({this.type, this.coordinates});

  LocationCoordinatesModel.fromJson(Map<String, dynamic> json) {
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

class DriverMetaConfigModel {
  String? firstName;
  String? lastName;
  bool? status;
  String? id;

  DriverMetaConfigModel({this.firstName, this.lastName, this.status, this.id});

  DriverMetaConfigModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class DriverInfoConfigModel {
  bool? activeStatus;
  bool? status;
  bool? isBlocked;
  String? id;

  DriverInfoConfigModel({this.activeStatus, this.status, this.isBlocked, this.id});

  DriverInfoConfigModel.fromJson(Map<String, dynamic> json) {
    activeStatus = json['activeStatus'];
    status = json['status'];
    isBlocked = json['isBlocked'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activeStatus'] = activeStatus;
    data['status'] = status;
    data['isBlocked'] = isBlocked;
    data['id'] = id;
    return data;
  }
}

class ActiveOrdersConfigModel {
  String? orderId;
  RestaurantActiveConfigModel? restaurant;
  String? driverOrderStatus;
  String? orderFrom;
  String? createdAt;
  String? id;
  DeliveryAddressRawConfigModel? deliveryAddressRaw;
  OrderInfoConfigModel? orderInfo;
  final String locale;

  ActiveOrdersConfigModel({this.orderId, this.restaurant, this.driverOrderStatus, this.orderFrom, this.createdAt, this.id, this.deliveryAddressRaw, this.orderInfo, required this.locale});

  ActiveOrdersConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    orderId = json['orderId'];
    restaurant = json['restaurant'] != null ? RestaurantActiveConfigModel.fromJson(json['restaurant'], locale) : null;
    driverOrderStatus = json['driverOrderStatus'];
    orderFrom = json['orderFrom'];
    createdAt = json['createdAt'];
    id = json['id'];
    deliveryAddressRaw = json['deliveryAddressRaw'] != null ? DeliveryAddressRawConfigModel.fromJson(json['deliveryAddressRaw']) : null;
    orderInfo = json['orderInfo'] != null ? OrderInfoConfigModel.fromJson(json['orderInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['driverOrderStatus'] = driverOrderStatus;
    data['orderFrom'] = orderFrom;
    data['createdAt'] = createdAt;
    data['id'] = id;
    if (deliveryAddressRaw != null) {
      data['deliveryAddressRaw'] = deliveryAddressRaw!.toJson();
    }
    if (orderInfo != null) {
      data['orderInfo'] = orderInfo!.toJson();
    }
    return data;
  }
}

class RestaurantActiveConfigModel {
  String? id;
  String? name;
  String? logo;
  String? cover;
  String? slug;
  String? address;
  LocationCoordinatesModel? location;
  List<Translations>? translations;
  final String locale;

  RestaurantActiveConfigModel({this.id, this.name, this.logo, this.cover, this.slug, this.address, this.location, this.translations, required this.locale});

  RestaurantActiveConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    cover = json['cover'];
    slug = json['slug'];
    address = json['address'];
    location = json['location'] != null ? LocationCoordinatesModel.fromJson(json['location']) : null;
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

class DeliveryAddressRawConfigModel {
  LocationCoordinatesModel? location;
  int? title;
  String? receiverName;
  int? countryCode;
  String? receiverContact;
  String? flatHouse;
  String? locality;
  String? landmark;
  String? id;
  String? fullAddress;

  DeliveryAddressRawConfigModel({this.location, this.title, this.receiverName, this.countryCode, this.receiverContact, this.flatHouse, this.locality, this.landmark, this.id, this.fullAddress});

  DeliveryAddressRawConfigModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? LocationCoordinatesModel.fromJson(json['location']) : null;
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
    fullAddress = '${json['flatHouse']}, ${json['locality']}, ${json['landmark']}';
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
    data['fullAddress'] = fullAddress;
    data['id'] = id;
    return data;
  }
}

class OrderInfoConfigModel {
  String? id;
  int? orderNo;

  OrderInfoConfigModel({this.id, this.orderNo});

  OrderInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderNo'] = orderNo;
    return data;
  }
}
