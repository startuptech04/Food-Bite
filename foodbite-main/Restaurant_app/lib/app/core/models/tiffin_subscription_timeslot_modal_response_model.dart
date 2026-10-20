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

class TiffinSubscriptionTimeSlotModalResponseModel {
  bool? action;
  String? start;
  String? end;

  TiffinSubscriptionTimeSlotModalResponseModel({this.action, this.start, this.end});

  TiffinSubscriptionTimeSlotModalResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
