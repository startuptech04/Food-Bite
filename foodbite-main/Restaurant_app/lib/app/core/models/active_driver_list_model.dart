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

class ActiveDriverListModel {
  List<DriverInfoConfig>? drivers;
  String? findMode;
  bool? success;

  ActiveDriverListModel({this.drivers, this.findMode, this.success});

  ActiveDriverListModel.fromJson(Map<String, dynamic> json) {
    if (json['drivers'] != null) {
      drivers = <DriverInfoConfig>[];
      json['drivers'].forEach((v) {
        drivers!.add(DriverInfoConfig.fromJson(v));
      });
    }
    if (json['findMode'] != null && json['findMode'] != '') {
      findMode = json['findMode'];
    } else {
      findMode = 'km';
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (drivers != null) {
      data['drivers'] = drivers!.map((v) => v.toJson()).toList();
    }
    data['findMode'] = findMode;
    data['success'] = success;
    return data;
  }
}

class DriverInfoConfig {
  String? distance;
  UsersInfoConfig? users;
  String? id;

  DriverInfoConfig({this.distance, this.users, this.id});

  DriverInfoConfig.fromJson(Map<String, dynamic> json) {
    if (json['distance'] != null && json['distance'] != '') {
      distance = double.parse(json['distance'].toString()).toStringAsFixed(1);
    } else {
      distance = '0.0';
    }
    users = json['users'] != null ? UsersInfoConfig.fromJson(json['users']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    if (users != null) {
      data['users'] = users!.toJson();
    }
    data['id'] = id;
    return data;
  }
}

class UsersInfoConfig {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? role;

  UsersInfoConfig({this.id, this.firstName, this.lastName, this.image, this.role});

  UsersInfoConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['role'] = role;
    return data;
  }
}
