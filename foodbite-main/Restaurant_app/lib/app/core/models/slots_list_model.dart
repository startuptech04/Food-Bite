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

class SlotListModel {
  List<TimeSlotList>? slots;
  String? id;

  SlotListModel({this.slots, this.id});

  SlotListModel.fromJson(Map<String, dynamic> json) {
    if (json['slots'] != null) {
      slots = <TimeSlotList>[];
      json['slots'].forEach((v) {
        slots!.add(TimeSlotList.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class TimeSlotList {
  int? day;
  List<TimeSlotElement>? times;

  TimeSlotList({this.day, this.times});

  TimeSlotList.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['times'] != null) {
      times = <TimeSlotElement>[];
      json['times'].forEach((v) {
        times!.add(TimeSlotElement.fromJson(v));
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

class TimeSlotElement {
  String? start;
  String? end;

  TimeSlotElement({this.start, this.end});

  TimeSlotElement.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
