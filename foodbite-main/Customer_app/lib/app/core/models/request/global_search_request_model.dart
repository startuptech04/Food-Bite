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

class GlobalSearchRequestModel {
  String? searchQuery;
  double? latitude;
  double? longitude;

  GlobalSearchRequestModel({this.searchQuery, this.latitude, this.longitude});

  GlobalSearchRequestModel.fromJson(Map<String, dynamic> json) {
    searchQuery = json['searchQuery'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['searchQuery'] = searchQuery;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
