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

import 'package:driver/app/core/models/request/payout_field_value_request_model.dart';

class UpdatePayoutMethodRequestModel {
  String? id;
  String? deliveryman;
  List<PayoutFieldValueRequestModel>? formElement;

  UpdatePayoutMethodRequestModel({this.id, this.deliveryman, this.formElement});

  UpdatePayoutMethodRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryman = json['deliveryman'];
    if (json['formElement'] != null) {
      formElement = <PayoutFieldValueRequestModel>[];
      json['formElement'].forEach((v) {
        formElement!.add(PayoutFieldValueRequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deliveryman'] = deliveryman;
    if (formElement != null) {
      data['formElement'] = formElement!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
