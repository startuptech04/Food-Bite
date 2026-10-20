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

class UserAvatarListResponseModel {
  List<UserAvatarConfigModel>? avatar;
  bool? success;

  UserAvatarListResponseModel({this.avatar, this.success});

  UserAvatarListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['avatar'] != null) {
      avatar = <UserAvatarConfigModel>[];
      json['avatar'].forEach((v) {
        avatar!.add(UserAvatarConfigModel.fromJson(v));
      });
    } else {
      avatar = [];
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (avatar != null) {
      data['avatar'] = avatar!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class UserAvatarConfigModel {
  String? avatar;
  bool? isDefault;
  bool? status;
  String? id;

  UserAvatarConfigModel({this.avatar, this.isDefault, this.status, this.id});

  UserAvatarConfigModel.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    isDefault = json['isDefault'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['isDefault'] = isDefault;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
