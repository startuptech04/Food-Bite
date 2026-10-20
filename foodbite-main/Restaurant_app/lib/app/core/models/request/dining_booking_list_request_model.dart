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

class DiningBookingListRequestModel {
  int? limit;
  int? page;
  String? vendor;
  String? status;

  DiningBookingListRequestModel({this.limit, this.page, this.vendor, required this.status});

  DiningBookingListRequestModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    vendor = json['vendor'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['vendor'] = vendor;
    data['status'] = status;
    return data;
  }
}
