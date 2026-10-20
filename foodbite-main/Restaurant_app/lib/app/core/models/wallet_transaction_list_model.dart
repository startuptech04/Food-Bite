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

class WalletTransactionListModel {
  List<WalletTransactionConfigModel>? transaction;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;

  WalletTransactionListModel({this.transaction, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  WalletTransactionListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['transaction'] != null) {
      transaction = <WalletTransactionConfigModel>[];
      json['transaction'].forEach((v) {
        transaction!.add(WalletTransactionConfigModel.fromJson(v, locale));
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
    if (transaction != null) {
      data['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class WalletTransactionConfigModel {
  String? type;
  bool? confirmed;
  bool? status;
  String? createdAt;
  String? uuid;
  String? id;
  double? amount;
  final String locale;

  WalletTransactionConfigModel({this.type, this.confirmed, this.status, this.createdAt, this.uuid, this.id, this.amount, required this.locale});

  WalletTransactionConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    type = json['type'];
    confirmed = json['confirmed'];
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '-';
    }
    uuid = json['uuid'];
    id = json['id'];
    if (json['amount'] != null && json['amount'] != '') {
      amount = double.parse(json['amount'].toString());
    } else {
      amount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['confirmed'] = confirmed;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['uuid'] = uuid;
    data['id'] = id;
    data['amount'] = amount;
    return data;
  }
}
