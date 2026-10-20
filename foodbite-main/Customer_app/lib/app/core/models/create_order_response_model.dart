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

class CreateOrderResponseModel {
  String? id;
  bool? success;
  String? status;
  String? payLink;

  CreateOrderResponseModel({this.id, this.success, this.status, this.payLink});

  CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    success = json['success'];
    status = json['status'];
    payLink = json['payLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['success'] = success;
    data['status'] = status;
    data['payLink'] = payLink;
    return data;
  }
}
