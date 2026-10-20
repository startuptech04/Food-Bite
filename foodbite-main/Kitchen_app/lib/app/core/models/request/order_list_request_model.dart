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

class OrderListRequestModel {
  int? limit;
  int? page;
  String? owner;
  String? status;

  OrderListRequestModel({this.limit, this.page, this.owner, this.status});

  OrderListRequestModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    owner = json['owner'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['owner'] = owner;
    data['status'] = status;
    return data;
  }
}
