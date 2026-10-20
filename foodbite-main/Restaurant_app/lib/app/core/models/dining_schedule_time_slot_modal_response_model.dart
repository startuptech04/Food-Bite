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

class DiningScheduleTimeSlotModalResponseModel {
  bool? action;
  String? type;
  String? time;

  DiningScheduleTimeSlotModalResponseModel({this.action, this.type, this.time});

  DiningScheduleTimeSlotModalResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    type = json['type'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['type'] = type;
    data['time'] = time;
    return data;
  }
}
