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

class TableListResponseModel {
  List<TableConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  TableListResponseModel({this.results, this.page, this.limit, this.totalPages, this.totalResults});

  TableListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <TableConfigModel>[];
      json['results'].forEach((v) {
        results!.add(TableConfigModel.fromJson(v));
      });
    }
    if (json['page'] != null && json['page'] != '') {
      page = int.parse(json['page'].toString());
    } else {
      page = 0;
    }
    if (json['limit'] != null && json['limit'] != '') {
      limit = int.parse(json['limit'].toString());
    } else {
      limit = 0;
    }
    if (json['totalPages'] != null && json['totalPages'] != '') {
      totalPages = int.parse(json['totalPages'].toString());
    } else {
      totalPages = 0;
    }
    if (json['totalResults'] != null && json['totalResults'] != '') {
      totalResults = int.parse(json['totalResults'].toString());
    } else {
      totalResults = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class TableConfigModel {
  int? tableNumber;
  int? capacity;
  bool? status;
  String? id;

  TableConfigModel({this.tableNumber, this.capacity, this.status, this.id});

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
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tableNumber'] = tableNumber;
    data['capacity'] = capacity;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}
