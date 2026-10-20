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

class GlobalSearchHistoryModel {
  String? id;
  String? title;
  String? subTitle;
  String? type;
  String? image;
  String? action;

  GlobalSearchHistoryModel({this.id, this.title, this.subTitle, this.type, this.image, this.action});

  GlobalSearchHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['subTitle'];
    type = json['type'];
    image = json['image'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['type'] = type;
    data['image'] = image;
    data['action'] = action;
    return data;
  }
}
