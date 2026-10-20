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

class PosOrderListModel {
  List<PosOrderConfigModel>? orders;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  PosOrderListModel({this.orders, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  PosOrderListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orders'] != null) {
      orders = <PosOrderConfigModel>[];
      json['orders'].forEach((v) {
        orders!.add(PosOrderConfigModel.fromJson(v, locale));
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

class PosOrderConfigModel {
  int? orderNo;
  String? customerType;
  String? customerName;
  String? paymentMode;
  String? orderFrom;
  bool? tableOrder;
  String? status;
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
  final String locale;
  PosOrderConfigModel({
    this.orderNo,
    this.customerType,
    this.customerName,
    this.paymentMode,
    this.orderFrom,
    this.tableOrder,
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
    required this.locale,
  });

  PosOrderConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    customerType = json['customerType'];
    customerName = json['customerName'];
    paymentMode = json['paymentMode'];
    orderFrom = json['orderFrom'];
    tableOrder = json['tableOrder'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderNo'] = orderNo;
    data['customerType'] = customerType;
    data['customerName'] = customerName;
    data['paymentMode'] = paymentMode;
    data['orderFrom'] = orderFrom;
    data['tableOrder'] = tableOrder;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['grandTotal'] = grandTotal;
    data['discountCharge'] = discountCharge;
    data['extraCharge'] = extraCharge;
    data['foodServiceCharge'] = foodServiceCharge;
    data['itemDiscount'] = itemDiscount;
    data['itemTotal'] = itemTotal;
    data['packageCharge'] = packageCharge;
    data['packageChargeTax'] = packageChargeTax;
    data['realTotal'] = realTotal;
    data['serviceCharge'] = serviceCharge;
    data['waiterTip'] = waiterTip;
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
