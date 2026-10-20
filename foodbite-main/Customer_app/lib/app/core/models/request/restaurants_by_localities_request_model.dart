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

class RestaurantsByLocalitiesRequestModel {
  String? from;
  String? slug;
  double? latitude;
  double? longitude;
  String? uid;
  int? limit;
  int? page;

  RestaurantsByLocalitiesRequestModel({this.from, this.slug, this.latitude, this.longitude, this.uid, this.limit, this.page});

  RestaurantsByLocalitiesRequestModel.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    slug = json['slug'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    uid = json['uid'];
    limit = json['limit'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['slug'] = slug;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['uid'] = uid;
    data['limit'] = limit;
    data['page'] = page;
    return data;
  }
}
