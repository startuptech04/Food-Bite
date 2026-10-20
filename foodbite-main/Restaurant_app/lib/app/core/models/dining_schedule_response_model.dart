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

class DiningScheduleResponseModel {
  List<DiningScheduleItemConfigModel>? slots;
  bool? success;

  DiningScheduleResponseModel({this.slots, this.success});

  DiningScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['slots'] != null) {
      slots = <DiningScheduleItemConfigModel>[];
      json['slots'].forEach((v) {
        slots!.add(DiningScheduleItemConfigModel.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class DiningScheduleItemConfigModel {
  int? day;
  List<TimeSlotConfigModel>? times;

  DiningScheduleItemConfigModel({this.day, this.times});

  DiningScheduleItemConfigModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['times'] != null) {
      times = <TimeSlotConfigModel>[];
      json['times'].forEach((v) {
        times!.add(TimeSlotConfigModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    if (times != null) {
      data['times'] = times!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlotConfigModel {
  String? type;
  String? time;

  TimeSlotConfigModel({this.type, this.time});

  TimeSlotConfigModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['time'] = time;
    return data;
  }
}
