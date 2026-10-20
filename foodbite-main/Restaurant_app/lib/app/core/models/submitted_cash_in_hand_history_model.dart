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

class SubmittedCashInHandHistoryListModel {
  List<SubmittedCashInHandConfigModel>? collected;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;

  SubmittedCashInHandHistoryListModel({this.collected, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  SubmittedCashInHandHistoryListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['collected'] != null) {
      collected = <SubmittedCashInHandConfigModel>[];
      json['collected'].forEach((v) {
        collected!.add(SubmittedCashInHandConfigModel.fromJson(v, locale));
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
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (collected != null) {
      data['collected'] = collected!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class SubmittedCashInHandConfigModel {
  String? method;
  String? reference;
  String? createdAt;
  String? id;
  double? cashCollected;
  double? walletAmount;
  final String locale;

  SubmittedCashInHandConfigModel({this.method, this.reference, this.createdAt, this.id, this.cashCollected, this.walletAmount, required this.locale});

  SubmittedCashInHandConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
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
