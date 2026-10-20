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
import 'package:vendor/app/core/models/food_in_cart_model.dart';

class CompletedTableOrderListModel {
  List<CompletedTableOrderConfigModel>? orders;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  CompletedTableOrderListModel({this.orders, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  CompletedTableOrderListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orders'] != null) {
      orders = <CompletedTableOrderConfigModel>[];
      json['orders'].forEach((v) {
        orders!.add(CompletedTableOrderConfigModel.fromJson(v, locale));
      });
    } else {
      orders = [];
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
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class CompletedTableOrderConfigModel {
  int? orderNo;
  String? paymentMode;
  String? customerType;
  String? customerName;
  bool? status;
  String? createdAt;
  String? id;
  double? realTotal;
  double? itemTotal;
  double? itemDiscount;
  double? discountCharge;
  double? foodServiceCharge;
  double? serviceCharge;
  double? packageCharge;
  double? packageChargeTax;
  double? waiterTip;
  double? extraCharge;
  double? grandTotal;
  List<FoodInCartModel>? cartItem;
  TableDetailConfigModel? tableDetail;
  final String locale;
  CompletedTableOrderConfigModel({
    this.orderNo,
    this.paymentMode,
    this.customerType,
    this.customerName,
    this.status,
    this.createdAt,
    this.id,
    this.realTotal,
    this.itemTotal,
    this.itemDiscount,
    this.discountCharge,
    this.foodServiceCharge,
    this.serviceCharge,
    this.packageCharge,
    this.packageChargeTax,
    this.waiterTip,
    this.extraCharge,
    this.grandTotal,
    this.cartItem,
    this.tableDetail,
    required this.locale,
  });

  CompletedTableOrderConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    paymentMode = json['paymentMode'];
    customerType = json['customerType'];
    customerName = json['customerName'];
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'] != '') {
      DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      createdAt = DateFormat.yMMMMd(locale).format(tempDate);
    } else {
      createdAt = '';
    }
    id = json['id'];

    if (json['realTotal'] != null && json['realTotal'] != '') {
      realTotal = double.parse(json['realTotal'].toString());
    } else {
      realTotal = 0;
    }

    if (json['itemTotal'] != null && json['itemTotal'] != '') {
      itemTotal = double.parse(json['itemTotal'].toString());
    } else {
      itemTotal = 0;
    }

    if (json['itemDiscount'] != null && json['itemDiscount'] != '') {
      itemDiscount = double.parse(json['itemDiscount'].toString());
    } else {
      itemDiscount = 0;
    }
    if (json['discountCharge'] != null && json['discountCharge'] != '') {
      discountCharge = double.parse(json['discountCharge'].toString());
    } else {
      discountCharge = 0;
    }

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

    if (json['packageCharge'] != null && json['packageCharge'] != '') {
      packageCharge = double.parse(json['packageCharge'].toString());
    } else {
      packageCharge = 0;
    }

    if (json['packageChargeTax'] != null && json['packageChargeTax'] != '') {
      packageChargeTax = double.parse(json['packageChargeTax'].toString());
    } else {
      packageChargeTax = 0;
    }

    if (json['waiterTip'] != null && json['waiterTip'] != '') {
      waiterTip = double.parse(json['waiterTip'].toString());
    } else {
      waiterTip = 0;
    }

    if (json['extraCharge'] != null && json['extraCharge'] != '') {
      extraCharge = double.parse(json['extraCharge'].toString());
    } else {
      extraCharge = 0;
    }

    if (json['grandTotal'] != null && json['grandTotal'] != '') {
      grandTotal = double.parse(json['grandTotal'].toString());
    } else {
      grandTotal = 0;
    }
    if (json['cartItem'] != null) {
      cartItem = <FoodInCartModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(FoodInCartModel.fromJson(v, locale));
      });
    } else {
      cartItem = [];
    }
    tableDetail = json['tableDetail'] != null ? TableDetailConfigModel.fromJson(json['tableDetail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderNo'] = orderNo;
    data['paymentMode'] = paymentMode;
    data['customerType'] = customerType;
    data['customerName'] = customerName;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['realTotal'] = realTotal;
    data['itemTotal'] = itemTotal;
    data['itemDiscount'] = itemDiscount;
    data['discountCharge'] = discountCharge;
    data['foodServiceCharge'] = foodServiceCharge;
    data['serviceCharge'] = serviceCharge;
    data['packageCharge'] = packageCharge;
    data['packageChargeTax'] = packageChargeTax;
    data['waiterTip'] = waiterTip;
    data['extraCharge'] = extraCharge;
    data['grandTotal'] = grandTotal;
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    if (tableDetail != null) {
      data['tableDetail'] = tableDetail!.toJson();
    }

    return data;
  }
}

class TableDetailConfigModel {
  String? id;
  int? tableNumber;

  TableDetailConfigModel({this.id, this.tableNumber});

  TableDetailConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['tableNumber'] != null && json['tableNumber'] != '') {
      tableNumber = int.parse(json['tableNumber'].toString());
    } else {
      tableNumber = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tableNumber'] = tableNumber;
    return data;
  }
}
