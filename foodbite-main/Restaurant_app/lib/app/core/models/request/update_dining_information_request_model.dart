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

class UpdateDiningInformationRequestModel {
  String? categories;
  List<DiningMenuConfigModel>? menu;
  List<String>? photos;

  UpdateDiningInformationRequestModel({this.categories, this.menu, this.photos});

  UpdateDiningInformationRequestModel.fromJson(Map<String, dynamic> json) {
    categories = json['categories'];
    if (json['menu'] != null) {
      menu = <DiningMenuConfigModel>[];
      json['menu'].forEach((v) {
        menu!.add(DiningMenuConfigModel.fromJson(v, ''));
      });
    }
    photos = json['photos'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    if (menu != null) {
      data['menu'] = menu!.map((v) => v.toJson()).toList();
    }
    data['photos'] = photos;
    return data;
  }
}
