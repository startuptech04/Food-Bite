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

class PayoutFieldValueRequestModel {
  String? fieldName;
  String? fieldType;
  String? fieldValue;

  PayoutFieldValueRequestModel({this.fieldName, this.fieldType, this.fieldValue});

  PayoutFieldValueRequestModel.fromJson(Map<String, dynamic> json) {
    fieldName = json['fieldName'];
    fieldType = json['fieldType'];
    fieldValue = json['fieldValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fieldName'] = fieldName;
    data['fieldType'] = fieldType;
    data['fieldValue'] = fieldValue;
    return data;
  }
}
