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

import 'package:driver/app/core/models/payout_method_model.dart';

class PayoutMethodDetailModel {
  PayoutMethodDetailConfigModel? methodData;
  bool? success;

  PayoutMethodDetailModel({this.methodData, this.success});

  PayoutMethodDetailModel.fromJson(Map<String, dynamic> json) {
    methodData = json['methodData'] != null ? PayoutMethodDetailConfigModel.fromJson(json['methodData']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (methodData != null) {
      data['methodData'] = methodData!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class PayoutMethodDetailConfigModel {
  String? method;
  List<SavedFormElementConfigModel>? formElement;
  String? id;
  PayoutMethodConfigDetailModel? methodDetail;

  PayoutMethodDetailConfigModel({this.method, this.formElement, this.id, this.methodDetail});

  PayoutMethodDetailConfigModel.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    if (json['formElement'] != null) {
      formElement = <SavedFormElementConfigModel>[];
      json['formElement'].forEach((v) {
        formElement!.add(SavedFormElementConfigModel.fromJson(v));
      });
    }
    id = json['id'];
    methodDetail = json['methodDetail'] != null ? PayoutMethodConfigDetailModel.fromJson(json['methodDetail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    if (formElement != null) {
      data['formElement'] = formElement!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    if (methodDetail != null) {
      data['methodDetail'] = methodDetail!.toJson();
    }
    return data;
  }
}

class SavedFormElementConfigModel {
  String? fieldName;
  String? fieldType;
  String? fieldValue;

  SavedFormElementConfigModel({this.fieldName, this.fieldType, this.fieldValue});

  SavedFormElementConfigModel.fromJson(Map<String, dynamic> json) {
    fieldName = json['fieldName'];
    fieldType = json['fieldType'];
    fieldValue = json['fieldValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fieldName'] = fieldName;
    data['fieldType'] = fieldType;
    data['fieldValue'] = fieldValue;
    return data;
  }
}

class PayoutMethodConfigDetailModel {
  String? name;
  List<FormElementConfigModel>? methodFormElement;

  PayoutMethodConfigDetailModel({this.name, this.methodFormElement});

  PayoutMethodConfigDetailModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['methodFormElement'] != null) {
      methodFormElement = <FormElementConfigModel>[];
      json['methodFormElement'].forEach((v) {
        methodFormElement!.add(FormElementConfigModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (methodFormElement != null) {
      data['methodFormElement'] = methodFormElement!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
