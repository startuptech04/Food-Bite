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

import 'package:vendor/app/core/models/dining_detail_response_model.dart';

class MenuAndPhotoResponseModel {
  List<DiningMenuConfigModel>? menuDetail;
  List<String>? diningPhotos;
  bool? success;
  final String locale;
  MenuAndPhotoResponseModel({this.menuDetail, this.diningPhotos, this.success, required this.locale});

  MenuAndPhotoResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['menuDetail'] != null) {
      menuDetail = <DiningMenuConfigModel>[];
      json['menuDetail'].forEach((v) {
        menuDetail!.add(DiningMenuConfigModel.fromJson(v, locale));
      });
    }
    diningPhotos = json['diningPhotos'].cast<String>();
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (menuDetail != null) {
      data['menuDetail'] = menuDetail!.map((v) => v.toJson()).toList();
    }
    data['diningPhotos'] = diningPhotos;
    data['success'] = success;
    return data;
  }
}
