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

import 'package:vendor/app/core/models/payout_method_model.dart';

class PayoutMethodListModel {
  List<PayoutMethodConfigModel>? methods;
  bool? success;
  final String locale;
  PayoutMethodListModel({this.methods, this.success, required this.locale});

  PayoutMethodListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['methods'] != null) {
      methods = <PayoutMethodConfigModel>[];
      json['methods'].forEach((v) {
        methods!.add(PayoutMethodConfigModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (methods != null) {
      data['methods'] = methods!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}
