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

class PosOrderDetailModel {
  PosDetailConfigModel? details;
  bool? success;
  final String locale;
  PosOrderDetailModel({this.details, this.success, required this.locale});

  PosOrderDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    details = json['details'] != null ? PosDetailConfigModel.fromJson(json['details'], locale) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class PosDetailConfigModel {
  int? orderNo;
  String? paymentMode;
  String? customerType;
  String? customerName;
  String? customerCountryCode;
  String? customerMobileNumber;
  String? discountType;
  String? orderFrom;
  bool? tableOrder;
  String? status;
  String? createdAt;
  String? id;
  double? discountAmount;
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
  PosDetailConfigModel({
    this.orderNo,
    this.paymentMode,
    this.customerType,
    this.customerName,
    this.customerCountryCode,
    this.customerMobileNumber,
    this.discountType,
    this.orderFrom,
    this.tableOrder,
    this.status,
    this.createdAt,
    this.id,
    this.discountAmount,
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

  PosDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    paymentMode = json['paymentMode'];
    customerType = json['customerType'];
    customerName = json['customerName'];
    if (json['customerCountryCode'] != null && json['customerCountryCode'] != '') {
      customerCountryCode = json['customerCountryCode'].toString();
    } else {
      customerCountryCode = '';
    }
    customerMobileNumber = json['customerMobileNumber'];
    discountType = json['discountType'];
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
    if (json['discountAmount'] != null && json['discountAmount'] != '') {
      discountAmount = double.parse(json['discountAmount'].toString());
    } else {
      discountAmount = 0;
    }

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
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderNo'] = orderNo;
    data['paymentMode'] = paymentMode;
    data['customerType'] = customerType;
    data['customerName'] = customerName;
    data['customerCountryCode'] = customerCountryCode;
    data['customerMobileNumber'] = customerMobileNumber;
    data['discountType'] = discountType;
    data['orderFrom'] = orderFrom;
    data['tableOrder'] = tableOrder;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['discountAmount'] = discountAmount;
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
    return data;
  }
}
