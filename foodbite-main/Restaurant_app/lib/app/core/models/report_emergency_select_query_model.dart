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

class ReportEmergencyFormSelectModel {
  String? report;
  String? label;

  ReportEmergencyFormSelectModel({this.report, this.label});

  ReportEmergencyFormSelectModel.fromJson(Map<String, dynamic> json) {
    report = json['report'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['report'] = report;
    data['label'] = label;
    return data;
  }
}
