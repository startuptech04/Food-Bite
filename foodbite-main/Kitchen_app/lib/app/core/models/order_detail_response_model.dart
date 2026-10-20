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
import 'package:kitchen/app/core/models/food_in_cart_model.dart';

class OrderDetailResponseModel {
  OrderDetailConfigModel? detail;
  bool? success;
  final String locale;

  OrderDetailResponseModel({this.detail, this.success, required this.locale});

  OrderDetailResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    detail = json['detail'] != null ? OrderDetailConfigModel.fromJson(json['detail'], locale) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class OrderDetailConfigModel {
  String? orderFrom;
  String? cookingInstruction;
  String? status;
  String? createdAt;
  String? id;
  OrderMetaDetailConfigModel? regularOrderInfo;
  OrderMetaDetailConfigModel? posOrderInfo;
  TableOrderMetaDetailConfigModel? tableOrder;
  List<FoodInCartModel>? cartItem;
  final String locale;

  OrderDetailConfigModel({this.orderFrom, this.cookingInstruction, this.status, this.createdAt, this.id, this.regularOrderInfo, this.posOrderInfo, this.tableOrder, this.cartItem, required this.locale});

  OrderDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    orderFrom = json['orderFrom'];
    cookingInstruction = json['cookingInstruction'];
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'] != '') {
      final utc = DateTime.parse(json['createdAt']);
      final local = utc.toLocal();
      final formatted = DateFormat('MMMM d, yyyy h:mm a', 'en_US').format(local);
      createdAt = formatted;
    } else {
      createdAt = '';
    }
    id = json['id'];
    regularOrderInfo = json['regularOrderInfo'] != null ? OrderMetaDetailConfigModel.fromJson(json['regularOrderInfo']) : null;
    posOrderInfo = json['posOrderInfo'] != null ? OrderMetaDetailConfigModel.fromJson(json['posOrderInfo']) : null;
    tableOrder = json['tableOrder'] != null ? TableOrderMetaDetailConfigModel.fromJson(json['tableOrder']) : null;
    if (json['cartItem'] != null) {
      cartItem = <FoodInCartModel>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(FoodInCartModel.fromJson(v, locale));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderFrom'] = orderFrom;
    data['cookingInstruction'] = cookingInstruction;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    if (regularOrderInfo != null) {
      data['regularOrderInfo'] = regularOrderInfo!.toJson();
    }
    if (posOrderInfo != null) {
      data['posOrderInfo'] = posOrderInfo!.toJson();
    }
    if (tableOrder != null) {
      data['tableOrder'] = tableOrder!.toJson();
    }
    if (cartItem != null) {
      data['cartItem'] = cartItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderMetaDetailConfigModel {
  String? id;
  int? orderNo;

  OrderMetaDetailConfigModel({this.id, this.orderNo});

  OrderMetaDetailConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderNo'] = orderNo;
    return data;
  }
}

class TableOrderMetaDetailConfigModel {
  String? id;
  int? tableNumber;

  TableOrderMetaDetailConfigModel({this.id, this.tableNumber});

  TableOrderMetaDetailConfigModel.fromJson(Map<String, dynamic> json) {
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
