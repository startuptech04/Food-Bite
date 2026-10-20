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

class FetchDriverNearToOrderResponseModel {
  List<DeliverymanConfigModel>? drivers;
  String? findMode;
  bool? success;

  FetchDriverNearToOrderResponseModel({this.drivers, this.findMode, this.success});

  FetchDriverNearToOrderResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['drivers'] != null) {
      drivers = <DeliverymanConfigModel>[];
      json['drivers'].forEach((v) {
        drivers!.add(DeliverymanConfigModel.fromJson(v));
      });
    }
    findMode = json['findMode'];
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

class DeliverymanConfigModel {
  String? type;
  int? orderHandling;
  double? rating;
  String? distance;
  String? id;
  int? totalRating;
  DeliverymanInfoConfigModel? driverInfo;

  DeliverymanConfigModel({this.type, this.orderHandling, this.rating, this.distance, this.id, this.totalRating, this.driverInfo});

  DeliverymanConfigModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['orderHandling'] != null && json['orderHandling'] != '') {
      orderHandling = int.parse(json['orderHandling'].toString());
    } else {
      orderHandling = 0;
    }
    if (json['rating'] != null && json['rating'] != '') {
      rating = double.parse(json['rating'].toString());
    } else {
      rating = 0;
    }
    if (json['distance'] != null && json['distance'] != '') {
      distance = double.parse(json['distance'].toString()).toStringAsFixed(2);
    } else {
      distance = '0';
    }
    id = json['id'];
    if (json['totalRating'] != null && json['totalRating'] != '') {
      totalRating = int.parse(json['totalRating'].toString());
    } else {
      totalRating = 0;
    }
    driverInfo = json['driverInfo'] != null ? DeliverymanInfoConfigModel.fromJson(json['driverInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['orderHandling'] = orderHandling;
    data['rating'] = rating;
    data['distance'] = distance;
    data['id'] = id;
    data['totalRating'] = totalRating;
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
    }
    return data;
  }
}

class DeliverymanInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? countryCode;
  String? mobile;

  DeliverymanInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.mobile});

  DeliverymanInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    return data;
  }
}
