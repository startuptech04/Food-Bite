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

class ModalNavigationBackResponseModel {
  bool? action;
  String? ids;
  String? names;

  ModalNavigationBackResponseModel({this.action, this.ids, this.names});

  ModalNavigationBackResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    ids = json['ids'];
    names = json['names'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['ids'] = ids;
    data['names'] = names;
    return data;
  }
}
