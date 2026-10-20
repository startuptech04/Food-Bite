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

class ProductReviewParamRequestModel {
  String? id;
  int? rate;
  String? message;

  ProductReviewParamRequestModel({this.id, this.rate, this.message});

  ProductReviewParamRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json['rate'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rate'] = rate;
    data['message'] = message;
    return data;
  }
}
