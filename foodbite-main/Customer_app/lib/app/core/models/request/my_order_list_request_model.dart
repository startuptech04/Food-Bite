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

class MyOrderListRequestModel {
  int? limit;
  int? page;
  String? uid;

  MyOrderListRequestModel({this.limit, this.page, this.uid});

  MyOrderListRequestModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['uid'] = uid;
    return data;
  }
}
