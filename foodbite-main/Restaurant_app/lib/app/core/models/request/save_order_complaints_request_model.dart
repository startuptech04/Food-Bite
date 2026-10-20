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

class SaveOrderComplaintRequestModel {
  String? orders;
  String? reason;
  String? title;
  String? brief;
  String? proof;
  String? issueWith;
  String? restaurant;
  String? driver;
  String? customer;
  String? user;

  SaveOrderComplaintRequestModel({this.orders, this.reason, this.title, this.brief, this.proof, this.issueWith, this.restaurant, this.driver, this.customer, this.user});

  SaveOrderComplaintRequestModel.fromJson(Map<String, dynamic> json) {
    orders = json['orders'];
    reason = json['reason'];
    title = json['title'];
    brief = json['brief'];
    proof = json['proof'];
    issueWith = json['issueWith'];
    restaurant = json['restaurant'];
    driver = json['driver'];
    customer = json['customer'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orders'] = orders;
    data['reason'] = reason;
    data['title'] = title;
    data['brief'] = brief;
    data['proof'] = proof;
    data['issueWith'] = issueWith;
    data['restaurant'] = restaurant;
    data['driver'] = driver;
    data['customer'] = customer;
    data['user'] = user;
    return data;
  }
}
