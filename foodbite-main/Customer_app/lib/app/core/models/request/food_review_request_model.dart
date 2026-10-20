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

class FoodReviewsRequestModel {
  String? id;
  int? limit;
  int? page;

  FoodReviewsRequestModel({this.id, this.limit, this.page});

  FoodReviewsRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    limit = json['limit'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['limit'] = limit;
    data['page'] = page;
    return data;
  }
}
