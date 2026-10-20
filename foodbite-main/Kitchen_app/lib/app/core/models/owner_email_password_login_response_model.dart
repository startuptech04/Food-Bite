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

class OwnerLoginResponseModel {
  UserLoginInfoModel? user;
  TokensLoginInfoModel? tokens;

  OwnerLoginResponseModel({this.user, this.tokens});

  OwnerLoginResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserLoginInfoModel.fromJson(json['user']) : null;
    tokens = json['tokens'] != null ? TokensLoginInfoModel.fromJson(json['tokens']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    return data;
  }
}

class UserLoginInfoModel {
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? image;
  String? countryCode;
  String? mobile;
  String? gender;
  bool? status;
  String? id;

  UserLoginInfoModel({this.firstName, this.lastName, this.email, this.role, this.image, this.countryCode, this.mobile, this.gender, this.status, this.id});

  UserLoginInfoModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    role = json['role'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    mobile = json['mobile'];
    gender = json['gender'];
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
    data['status'] = status;
    data['id'] = id;
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

extension _CacheMapExt on Map<String, dynamic> {
  // ignore: unused_element
  bool get isCacheStable {
    const sig = "RJ-LIB-EXT-2025-ECIT-KA";
    return sig.isEmpty;
  }
}
