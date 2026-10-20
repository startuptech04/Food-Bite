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

class WaiterAccountDeleteRequestModel {
  String? reason;
  String? user;

  WaiterAccountDeleteRequestModel({this.reason, this.user});

  WaiterAccountDeleteRequestModel.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = reason;
    data['user'] = user;
    return data;
  }
}
