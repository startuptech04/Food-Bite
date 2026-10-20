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

class WaiterListResponseModel {
  List<WaiterDetailConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;

  WaiterListResponseModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, this.success});

  WaiterListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <WaiterDetailConfigModel>[];
      json['results'].forEach((v) {
        results!.add(WaiterDetailConfigModel.fromJson(v));
      });
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
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class WaiterDetailConfigModel {
  double? rating;
  int? totalRating;
  bool? status;
  String? id;
  WaiterInfoConfigModel? waiterInfo;

  WaiterDetailConfigModel({this.rating, this.totalRating, this.status, this.id, this.waiterInfo});

  WaiterDetailConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['rating'] != null && json['rating'] != '') {
      rating = double.parse(json['rating'].toString());
    } else {
      rating = 0;
    }
    if (json['totalRating'] != null && json['totalRating'] != '') {
      totalRating = int.parse(json['totalRating']);
    } else {
      totalRating = 0;
    }
    status = json['status'];
    id = json['id'];
    waiterInfo = json['waiterInfo'] != null ? WaiterInfoConfigModel.fromJson(json['waiterInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['status'] = status;
    data['id'] = id;
    if (waiterInfo != null) {
      data['waiterInfo'] = waiterInfo!.toJson();
    }
    return data;
  }
}

class WaiterInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? countryCode;
  String? contactNumber;
  String? contactEmail;

  WaiterInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.contactNumber, this.contactEmail});

  WaiterInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    contactNumber = json['contactNumber'];
    contactEmail = json['contactEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['contactNumber'] = contactNumber;
    data['contactEmail'] = contactEmail;
    return data;
  }
}
