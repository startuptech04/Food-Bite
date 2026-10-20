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

class LocalSearchHistoryModel {
  String? description;
  String? mainText;
  String? placeId;
  double? latitude;
  double? longitude;

  LocalSearchHistoryModel({this.description, this.mainText, this.placeId, this.latitude, this.longitude});

  LocalSearchHistoryModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    mainText = json['main_text'];
    placeId = json['place_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['main_text'] = mainText;
    data['place_id'] = placeId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
