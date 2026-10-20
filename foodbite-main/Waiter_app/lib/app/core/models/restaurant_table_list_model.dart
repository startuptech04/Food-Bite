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

class RestaurantTableListModel {
  List<TableConfigModel>? tables;
  bool? success;

  RestaurantTableListModel({this.tables, this.success});

  RestaurantTableListModel.fromJson(Map<String, dynamic> json) {
    if (json['tables'] != null) {
      tables = <TableConfigModel>[];
      json['tables'].forEach((v) {
        tables!.add(TableConfigModel.fromJson(v));
      });
    } else {
      tables = [];
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tables != null) {
      data['tables'] = tables!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class TableConfigModel {
  int? tableNumber;
  int? capacity;
  bool? occupied;
  String? id;

  TableConfigModel({this.tableNumber, this.capacity, this.occupied, this.id});

  TableConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['tableNumber'] != null && json['tableNumber'] != '') {
      tableNumber = int.parse(json['tableNumber'].toString());
    } else {
      tableNumber = 0;
    }
    if (json['capacity'] != null && json['capacity'] != '') {
      capacity = int.parse(json['capacity'].toString());
    } else {
      capacity = 0;
    }
    if (json['occupied'] != null && json['occupied'] != '') {
      occupied = json['occupied'];
    } else {
      occupied = false;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tableNumber'] = tableNumber;
    data['capacity'] = capacity;
    data['occupied'] = occupied;
    data['id'] = id;
    return data;
  }
}
