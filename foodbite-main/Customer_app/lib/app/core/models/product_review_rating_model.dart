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

import 'package:user/app/core/models/order_detail_for_review_model.dart';

class ProductReviewRatingModel {
  String? id;
  String? name;
  int? rate;
  List<String>? msg;
  List<OrderRatingMessagesConfigModel>? messages;
  final String locale;
  ProductReviewRatingModel({this.id, this.name, this.rate, this.msg, this.messages, required this.locale});

  ProductReviewRatingModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    msg = json['msg'].cast<String>();
    if (json['messages'] != null) {
      messages = <OrderRatingMessagesConfigModel>[];
      json['messages'].forEach((v) {
        messages!.add(OrderRatingMessagesConfigModel.fromJson(v, locale));
      });
    } else {
      messages = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rate'] = rate;
    data['msg'] = msg;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
