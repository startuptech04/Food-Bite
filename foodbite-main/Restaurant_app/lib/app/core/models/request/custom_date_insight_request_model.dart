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

class CustomDateInsightRequestModel {
  String? vendor;
  String? startDate;
  String? endDate;

  CustomDateInsightRequestModel({this.vendor, this.startDate, this.endDate});

  CustomDateInsightRequestModel.fromJson(Map<String, dynamic> json) {
    vendor = json['vendor'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor'] = vendor;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
