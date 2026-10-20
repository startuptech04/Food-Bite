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

import 'package:vendor/app/core/models/expense_model.dart';

class ExpenseInitialResponeModel {
  TotalExpenseData? totalExpenseData;
  TotalExpenseData? orderProductDiscountExpenseData;
  TotalExpenseData? posOrderProductDiscountExpenseData;
  TotalExpenseData? tableOrderProductDiscountExpenseData;
  TotalExpenseData? posOrderExtraDiscountExpenseData;
  TotalExpenseData? tableOrderExtraDiscountExpenseData;
  TotalExpenseData? couponExpenseData;
  TotalExpenseData? diningCouponExpenseData;
  TotalExpenseData? diningBookingDiscountExpenseData;
  TotalExpenseData? refundOrderExpenseData;
  TotalExpenseData? otherExpenseData;
  List<ExpenseModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;
  ExpenseInitialResponeModel({
    this.totalExpenseData,
    this.orderProductDiscountExpenseData,
    this.posOrderProductDiscountExpenseData,
    this.tableOrderProductDiscountExpenseData,
    this.posOrderExtraDiscountExpenseData,
    this.tableOrderExtraDiscountExpenseData,
    this.couponExpenseData,
    this.diningCouponExpenseData,
    this.diningBookingDiscountExpenseData,
    this.refundOrderExpenseData,
    this.otherExpenseData,
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
    required this.locale,
  });

  ExpenseInitialResponeModel.fromJson(Map<String, dynamic> json, this.locale) {
    totalExpenseData = json['totalExpenseData'] != null ? TotalExpenseData.fromJson(json['totalExpenseData']) : null;
    orderProductDiscountExpenseData = json['orderProductDiscountExpenseData'] != null ? TotalExpenseData.fromJson(json['orderProductDiscountExpenseData']) : null;
    posOrderProductDiscountExpenseData = json['posOrderProductDiscountExpenseData'] != null ? TotalExpenseData.fromJson(json['posOrderProductDiscountExpenseData']) : null;
    tableOrderProductDiscountExpenseData = json['tableOrderProductDiscountExpenseData'] != null ? TotalExpenseData.fromJson(json['tableOrderProductDiscountExpenseData']) : null;
    posOrderExtraDiscountExpenseData = json['posOrderExtraDiscountExpenseData'] != null ? TotalExpenseData.fromJson(json['posOrderExtraDiscountExpenseData']) : null;
    tableOrderExtraDiscountExpenseData = json['tableOrderExtraDiscountExpenseData'] != null ? TotalExpenseData.fromJson(json['tableOrderExtraDiscountExpenseData']) : null;
    couponExpenseData = json['couponExpenseData'] != null ? TotalExpenseData.fromJson(json['couponExpenseData']) : null;
    diningCouponExpenseData = json['diningCouponExpenseData'] != null ? TotalExpenseData.fromJson(json['diningCouponExpenseData']) : null;
    diningBookingDiscountExpenseData = json['diningBookingDiscountExpenseData'] != null ? TotalExpenseData.fromJson(json['diningBookingDiscountExpenseData']) : null;
    refundOrderExpenseData = json['refundOrderExpenseData'] != null ? TotalExpenseData.fromJson(json['refundOrderExpenseData']) : null;
    otherExpenseData = json['otherExpenseData'] != null ? TotalExpenseData.fromJson(json['otherExpenseData']) : null;
    if (json['results'] != null) {
      results = <ExpenseModel>[];
      json['results'].forEach((v) {
        results!.add(ExpenseModel.fromJson(v, locale));
      });
    } else {
      results = [];
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
    if (totalExpenseData != null) {
      data['totalExpenseData'] = totalExpenseData!.toJson();
    }
    if (orderProductDiscountExpenseData != null) {
      data['orderProductDiscountExpenseData'] = orderProductDiscountExpenseData!.toJson();
    }
    if (posOrderProductDiscountExpenseData != null) {
      data['posOrderProductDiscountExpenseData'] = posOrderProductDiscountExpenseData!.toJson();
    }
    if (tableOrderProductDiscountExpenseData != null) {
      data['tableOrderProductDiscountExpenseData'] = tableOrderProductDiscountExpenseData!.toJson();
    }
    if (posOrderExtraDiscountExpenseData != null) {
      data['posOrderExtraDiscountExpenseData'] = posOrderExtraDiscountExpenseData!.toJson();
    }
    if (tableOrderExtraDiscountExpenseData != null) {
      data['tableOrderExtraDiscountExpenseData'] = tableOrderExtraDiscountExpenseData!.toJson();
    }
    if (couponExpenseData != null) {
      data['couponExpenseData'] = couponExpenseData!.toJson();
    }
    if (diningCouponExpenseData != null) {
      data['diningCouponExpenseData'] = diningCouponExpenseData!.toJson();
    }
    if (diningBookingDiscountExpenseData != null) {
      data['diningBookingDiscountExpenseData'] = diningBookingDiscountExpenseData!.toJson();
    }
    if (refundOrderExpenseData != null) {
      data['refundOrderExpenseData'] = refundOrderExpenseData!.toJson();
    }
    if (otherExpenseData != null) {
      data['otherExpenseData'] = otherExpenseData!.toJson();
    }
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

class TotalExpenseData {
  int? count;
  double? amount;

  TotalExpenseData({this.count, this.amount});

  TotalExpenseData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['amount'] != null && json['amount'] != '') {
      amount = double.parse(json['amount'].toString());
    } else {
      amount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['amount'] = amount;
    return data;
  }
}
