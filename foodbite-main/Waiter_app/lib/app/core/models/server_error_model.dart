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

class ServerErrorModel {
  int? code;
  String? message;
  String? stack;
  String? extra;

  ServerErrorModel({this.code, this.message, this.stack, this.extra});

  ServerErrorModel.fromJson(Map<String, dynamic> json) {
    if (json['code'] != null && json['code'] != '') {
      code = json['code'];
    } else {
      code = 0;
    }
    if (json['message'] != null && json['message'] != '') {
      message = json['message'];
    } else {
      message = '';
    }

    if (json['stack'] != null && json['stack'] != '') {
      stack = json['stack'];
    } else {
      stack = '';
    }
    if (json['extra'] != null && json['extra'] != '') {
      extra = json['extra'];
    } else {
      extra = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['stack'] = stack;
    data['extra'] = extra;
    return data;
  }
}
