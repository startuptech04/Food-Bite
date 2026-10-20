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

class VendorLoginResponseModel {
  UserLoginInfoModel? user;
  TokensLoginInfoModel? tokens;
  VendorLoginInfoModel? vendor;
  ManagerLoginInfoModel? manager;
  RestaurantInfoConfigModel? restaurant;

  VendorLoginResponseModel({this.user, this.tokens, this.vendor, this.manager, this.restaurant});

  VendorLoginResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserLoginInfoModel.fromJson(json['user']) : null;
    tokens = json['tokens'] != null ? TokensLoginInfoModel.fromJson(json['tokens']) : null;
    vendor = json['vendor'] != null ? VendorLoginInfoModel.fromJson(json['vendor']) : null;
    manager = json['manager'] != null ? ManagerLoginInfoModel.fromJson(json['manager']) : null;
    restaurant = json['restaurant'] != null ? RestaurantInfoConfigModel.fromJson(json['restaurant']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    if (manager != null) {
      data['manager'] = manager!.toJson();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    return data;
  }
}

class UserLoginInfoModel {
  String? id;
  String? role;
  String? email;
  String? countryCode;
  String? mobile;
  String? firstName;
  String? lastName;
  String? image;

  UserLoginInfoModel({this.id, this.role, this.email, this.countryCode, this.mobile, this.firstName, this.lastName, this.image});

  UserLoginInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    email = json['email'];
    countryCode = json['countryCode'].toString();
    mobile = json['mobile'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    return data;
  }
}

class TokensLoginInfoModel {
  AccessTokenModel? access;
  AccessTokenModel? refresh;

  TokensLoginInfoModel({this.access, this.refresh});

  TokensLoginInfoModel.fromJson(Map<String, dynamic> json) {
    access = json['access'] != null ? AccessTokenModel.fromJson(json['access']) : null;
    refresh = json['refresh'] != null ? AccessTokenModel.fromJson(json['refresh']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (access != null) {
      data['access'] = access!.toJson();
    }
    if (refresh != null) {
      data['refresh'] = refresh!.toJson();
    }
    return data;
  }
}

class AccessTokenModel {
  String? token;
  String? expires;

  AccessTokenModel({this.token, this.expires});

  AccessTokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expires'] = expires;
    return data;
  }
}

class VendorLoginInfoModel {
  String? userId;
  String? type;
  bool? pos;
  bool? ownDriver;
  bool? promote;
  bool? customCategory;
  bool? multiOutlet;
  bool? preBooking;
  bool? tableOrder;
  bool? tiffinSubscription;
  bool? ownWaiter;
  bool? ownKitchen;
  bool? isOutlet;
  String? outletManagerId;
  bool? status;
  String? id;

  VendorLoginInfoModel({
    this.userId,
    this.type,
    this.pos,
    this.ownDriver,
    this.promote,
    this.customCategory,
    this.multiOutlet,
    this.preBooking,
    this.tableOrder,
    this.tiffinSubscription,
    this.ownWaiter,
    this.ownKitchen,
    this.isOutlet,
    this.outletManagerId,
    this.status,
    this.id,
  });

  VendorLoginInfoModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    type = json['type'];
    pos = json['pos'];
    ownDriver = json['ownDriver'];
    promote = json['promote'];
    customCategory = json['customCategory'];
    multiOutlet = json['multiOutlet'];
    preBooking = json['preBooking'];
    tableOrder = json['tableOrder'];
    tiffinSubscription = json['tiffinSubscription'];
    ownWaiter = json['ownWaiter'];
    ownKitchen = json['ownKitchen'];
    isOutlet = json['isOutlet'];
    outletManagerId = json['outletManagerId'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['type'] = type;
    data['pos'] = pos;
    data['ownDriver'] = ownDriver;
    data['promote'] = promote;
    data['customCategory'] = customCategory;
    data['multiOutlet'] = multiOutlet;
    data['preBooking'] = preBooking;
    data['tableOrder'] = tableOrder;
    data['tiffinSubscription'] = tiffinSubscription;
    data['ownWaiter'] = ownWaiter;
    data['ownKitchen'] = ownKitchen;
    data['isOutlet'] = isOutlet;
    data['outletManagerId'] = outletManagerId;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class ManagerLoginInfoModel {
  bool? pos;
  bool? ownDriver;
  bool? promote;
  bool? customCategory;
  bool? multiOutlet;
  bool? preBooking;
  bool? tableOrder;
  bool? tiffinSubscription;
  bool? ownWaiter;
  bool? ownKitchen;
  bool? status;
  String? id;

  ManagerLoginInfoModel({this.pos, this.ownDriver, this.promote, this.customCategory, this.multiOutlet, this.preBooking, this.tableOrder, this.tiffinSubscription, this.ownWaiter, this.ownKitchen, this.status, this.id});

  ManagerLoginInfoModel.fromJson(Map<String, dynamic> json) {
    pos = json['pos'];
    ownDriver = json['ownDriver'];
    promote = json['promote'];
    customCategory = json['customCategory'];
    multiOutlet = json['multiOutlet'];
    preBooking = json['preBooking'];
    tableOrder = json['tableOrder'];
    tiffinSubscription = json['tiffinSubscription'];
    ownWaiter = json['ownWaiter'];
    ownKitchen = json['ownKitchen'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pos'] = pos;
    data['ownDriver'] = ownDriver;
    data['promote'] = promote;
    data['customCategory'] = customCategory;
    data['multiOutlet'] = multiOutlet;
    data['preBooking'] = preBooking;
    data['tableOrder'] = tableOrder;
    data['tiffinSubscription'] = tiffinSubscription;
    data['ownWaiter'] = ownWaiter;
    data['ownKitchen'] = ownKitchen;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class RestaurantInfoConfigModel {
  String? name;
  String? address;
  String? logo;
  double? rating;
  String? id;

  RestaurantInfoConfigModel({this.name, this.address, this.logo, this.rating, this.id});

  RestaurantInfoConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    logo = json['logo'];
    if (json['rating'] != null && json['rating'] != '') {
      rating = double.parse(json['rating'].toString());
    } else {
      rating = 0.0;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['logo'] = logo;
    data['rating'] = rating;
    data['id'] = id;
    return data;
  }
}
