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

import 'package:intl/intl.dart';

class PosAndTableOrderCommissionHistoryListModel {
  List<PosAndTableOrderCommissionHistoryConfigModel>? history;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;

  PosAndTableOrderCommissionHistoryListModel({this.history, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  PosAndTableOrderCommissionHistoryListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['history'] != null) {
      history = <PosAndTableOrderCommissionHistoryConfigModel>[];
      json['history'].forEach((v) {
        history!.add(PosAndTableOrderCommissionHistoryConfigModel.fromJson(v, locale));
      });
    } else {
      history = [];
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
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class PosAndTableOrderCommissionHistoryConfigModel {
  bool? status;
  String? createdAt;
  String? id;
  PosOrTableOrderInfoConfigModel? posOrderInfo;
  PosOrTableOrderInfoConfigModel? tableOrderInfo;
  double? foodServiceCharge;
  double? serviceCharge;
  double? orderCommission;
  double? totalCommision;
  final String locale;

  PosAndTableOrderCommissionHistoryConfigModel({
    this.status,
    this.createdAt,
    this.id,
    this.posOrderInfo,
    this.tableOrderInfo,
    this.foodServiceCharge,
    this.serviceCharge,
    this.orderCommission,
    this.totalCommision,
    required this.locale,
  });

  PosAndTableOrderCommissionHistoryConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '-';
    }
    id = json['id'];
    posOrderInfo = json['posOrderInfo'] != null ? PosOrTableOrderInfoConfigModel.fromJson(json['posOrderInfo']) : null;
    tableOrderInfo = json['tableOrderInfo'] != null ? PosOrTableOrderInfoConfigModel.fromJson(json['tableOrderInfo']) : null;
    if (json['foodServiceCharge'] != null && json['foodServiceCharge'] != '') {
      foodServiceCharge = double.parse(json['foodServiceCharge'].toString());
    } else {
      foodServiceCharge = 0;
    }
    if (json['serviceCharge'] != null && json['serviceCharge'] != '') {
      serviceCharge = double.parse(json['serviceCharge'].toString());
    } else {
      serviceCharge = 0;
    }
    if (json['orderCommission'] != null && json['orderCommission'] != '') {
      orderCommission = double.parse(json['orderCommission'].toString());
    } else {
      orderCommission = 0;
    }
    if (json['totalCommision'] != null && json['totalCommision'] != '') {
      totalCommision = double.parse(json['totalCommision'].toString());
    } else {
      totalCommision = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    if (posOrderInfo != null) {
      data['posOrderInfo'] = posOrderInfo!.toJson();
    }
    if (tableOrderInfo != null) {
      data['tableOrderInfo'] = tableOrderInfo!.toJson();
    }
    data['foodServiceCharge'] = foodServiceCharge;
    data['serviceCharge'] = serviceCharge;
    data['orderCommission'] = orderCommission;
    data['totalCommision'] = totalCommision;
    return data;
  }
}

class PosOrTableOrderInfoConfigModel {
  String? id;
  int? orderNo;
  double? grandTotal;

  PosOrTableOrderInfoConfigModel({this.id, this.orderNo, this.grandTotal});

  PosOrTableOrderInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 1;
    }
    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderNo'] = orderNo;
    data['grandTotal'] = grandTotal;
    return data;
  }
}
