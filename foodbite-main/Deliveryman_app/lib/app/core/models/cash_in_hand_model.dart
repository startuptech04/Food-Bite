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

class CashInHandModel {
  double? cashInHandAmount;
  List<CashInHandHistoryConfigModel>? history;
  List<CollectedCashConfigModel>? collected;
  int? page;
  int? limit;
  int? totalHistoryPages;
  int? totalHistoryResults;
  int? totalCollectedPages;
  int? totalCollectedResults;
  bool? success;
  final String locale;

  CashInHandModel({
    this.cashInHandAmount,
    this.history,
    this.collected,
    this.page,
    this.limit,
    this.totalHistoryPages,
    this.totalHistoryResults,
    this.totalCollectedPages,
    this.totalCollectedResults,
    this.success,
    required this.locale,
  });

  CashInHandModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['cashInHandAmount'] != null && json['cashInHandAmount'] != '') {
      cashInHandAmount = double.parse(json['cashInHandAmount'].toString());
    } else {
      cashInHandAmount = 0;
    }
    if (json['history'] != null) {
      history = <CashInHandHistoryConfigModel>[];
      json['history'].forEach((v) {
        history!.add(CashInHandHistoryConfigModel.fromJson(v, locale));
      });
    } else {
      history = [];
    }
    if (json['collected'] != null) {
      collected = <CollectedCashConfigModel>[];
      json['collected'].forEach((v) {
        collected!.add(CollectedCashConfigModel.fromJson(v, locale));
      });
    } else {
      collected = [];
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
    if (json['totalHistoryPages'] != null && json['totalHistoryPages'] != '') {
      totalHistoryPages = int.parse(json['totalHistoryPages'].toString());
    } else {
      totalHistoryPages = 0;
    }
    if (json['totalHistoryResults'] != null && json['totalHistoryResults'] != '') {
      totalHistoryResults = int.parse(json['totalHistoryResults'].toString());
    } else {
      totalHistoryResults = 0;
    }
    if (json['totalCollectedPages'] != null && json['totalCollectedPages'] != '') {
      totalCollectedPages = int.parse(json['totalCollectedPages'].toString());
    } else {
      totalCollectedPages = 0;
    }
    if (json['totalCollectedResults'] != null && json['totalCollectedResults'] != '') {
      totalCollectedResults = int.parse(json['totalCollectedResults'].toString());
    } else {
      totalCollectedResults = 0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cashInHandAmount'] = cashInHandAmount;
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    if (collected != null) {
      data['collected'] = collected!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalHistoryPages'] = totalHistoryPages;
    data['totalHistoryResults'] = totalHistoryResults;
    data['totalCollectedPages'] = totalCollectedPages;
    data['totalCollectedResults'] = totalCollectedResults;
    data['success'] = success;
    return data;
  }
}

class CashInHandHistoryConfigModel {
  bool? status;
  String? createdAt;
  String? id;
  OrderInfoConfigModel? orderInfo;
  final String locale;

  CashInHandHistoryConfigModel({this.status, this.createdAt, this.id, this.orderInfo, required this.locale});

  CashInHandHistoryConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '-';
    }
    id = json['id'];
    orderInfo = json['orderInfo'] != null ? OrderInfoConfigModel.fromJson(json['orderInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    if (orderInfo != null) {
      data['orderInfo'] = orderInfo!.toJson();
    }
    return data;
  }
}

class OrderInfoConfigModel {
  String? id;
  int? orderNo;
  double? grandTotal;

  OrderInfoConfigModel({this.id, this.orderNo, this.grandTotal});

  OrderInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
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

class CollectedCashConfigModel {
  String? method;
  String? reference;
  String? createdAt;
  String? id;
  double? cashCollected;
  double? walletAmount;
  final String locale;

  CollectedCashConfigModel({this.method, this.reference, this.createdAt, this.id, this.cashCollected, this.walletAmount, required this.locale});

  CollectedCashConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    method = json['method'];
    reference = json['reference'];
    if (json['createdAt'] != null && json['createdAt'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '-';
    }
    id = json['id'];
    if (json['cashCollected'] != null && json['cashCollected'] != '') {
      cashCollected = double.parse(json['cashCollected'].toString());
    } else {
      cashCollected = 0;
    }
    if (json['walletAmount'] != null && json['walletAmount'] != '') {
      walletAmount = double.parse(json['walletAmount'].toString());
    } else {
      walletAmount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    data['reference'] = reference;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['cashCollected'] = cashCollected;
    data['walletAmount'] = walletAmount;
    return data;
  }
}
