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

class CustomTabListModel {
  String? label;
  String? key;
  int? orderNo;
  int? countNumber;

  CustomTabListModel({this.label, this.key, this.orderNo, this.countNumber});

  CustomTabListModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    key = json['key'];
    if (json['orderNo'] != null && json['orderNo'] != '') {
      orderNo = int.parse(json['orderNo'].toString());
    } else {
      orderNo = 0;
    }
    if (json['countNumber'] != null && json['countNumber'] != '') {
      countNumber = int.parse(json['countNumber'].toString());
    } else {
      countNumber = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['key'] = key;
    data['orderNo'] = orderNo;
    data['countNumber'] = countNumber;
    return data;
  }
}
