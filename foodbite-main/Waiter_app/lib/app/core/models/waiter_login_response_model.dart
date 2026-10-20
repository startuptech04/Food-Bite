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

class WaiterLoginResponseModel {
  WaiterUserInfoConfigModel? user;
  AuthTokenConfigModel? tokens;
  WaiterInfoConfigModel? waiter;

  WaiterLoginResponseModel({this.user, this.tokens, this.waiter});

  WaiterLoginResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? WaiterUserInfoConfigModel.fromJson(json['user']) : null;
    tokens = json['tokens'] != null ? AuthTokenConfigModel.fromJson(json['tokens']) : null;
    waiter = json['waiter'] != null ? WaiterInfoConfigModel.fromJson(json['waiter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    if (waiter != null) {
      data['waiter'] = waiter!.toJson();
    }
    return data;
  }
}

class WaiterUserInfoConfigModel {
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? image;
  String? countryCode;
  String? mobile;
  String? gender;
  String? locale;
  bool? status;
  String? id;

  WaiterUserInfoConfigModel({this.firstName, this.lastName, this.email, this.role, this.image, this.countryCode, this.mobile, this.gender, this.locale, this.status, this.id});

  WaiterUserInfoConfigModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    role = json['role'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    mobile = json['mobile'];
    gender = json['gender'];
    locale = json['locale'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['role'] = role;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['locale'] = locale;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class AuthTokenConfigModel {
  TokenConfigModel? access;
  TokenConfigModel? refresh;

  AuthTokenConfigModel({this.access, this.refresh});

  AuthTokenConfigModel.fromJson(Map<String, dynamic> json) {
    access = json['access'] != null ? TokenConfigModel.fromJson(json['access']) : null;
    refresh = json['refresh'] != null ? TokenConfigModel.fromJson(json['refresh']) : null;
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

class TokenConfigModel {
  String? token;
  String? expires;

  TokenConfigModel({this.token, this.expires});

  TokenConfigModel.fromJson(Map<String, dynamic> json) {
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

class WaiterInfoConfigModel {
  String? userId;
  String? restaurant;
  double? rating;
  bool? status;
  String? id;

  WaiterInfoConfigModel({this.userId, this.restaurant, this.rating, this.status, this.id});

  WaiterInfoConfigModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    restaurant = json['restaurant'];
    if (json['rating'] != null && json['rating'] != '') {
      rating = double.parse(json['rating'].toString());
    } else {
      rating = 0;
    }
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['restaurant'] = restaurant;
    data['rating'] = rating;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
