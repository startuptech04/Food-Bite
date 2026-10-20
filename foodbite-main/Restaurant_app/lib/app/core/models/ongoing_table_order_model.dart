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

class OngoingTableOrderModel {
  List<TableConfigModel>? tables;
  bool? success;

  OngoingTableOrderModel({this.tables, this.success});

  OngoingTableOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['tables'] != null) {
      tables = <TableConfigModel>[];
      json['tables'].forEach((v) {
        tables!.add(TableConfigModel.fromJson(v));
      });
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
  String? id;
  bool? occupied;

  TableConfigModel({
    this.tableNumber,
    this.id,
    this.occupied,
  });

  TableConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['tableNumber'] != null && json['tableNumber'] != '') {
      tableNumber = int.parse(json['tableNumber'].toString());
    } else {
      tableNumber = 1;
    }
    id = json['id'];
    if (json['occupied'] != null && json['occupied'] != '') {
      occupied = json['occupied'];
    } else {
      occupied = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tableNumber'] = tableNumber;
    data['id'] = id;
    data['occupied'] = occupied;
    return data;
  }
}
