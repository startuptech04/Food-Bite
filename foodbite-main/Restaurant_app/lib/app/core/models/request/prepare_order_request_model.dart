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

class PrepareOrderRequestModel {
  String? id;
  int? time;
  String? vendorId;
  String? driverId;
  String? user;

  PrepareOrderRequestModel({this.id, this.time, this.vendorId, this.driverId, this.user});

  PrepareOrderRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    vendorId = json['vendorId'];
    driverId = json['driverId'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time;
    data['vendorId'] = vendorId;
    data['driverId'] = driverId;
    data['user'] = user;
    return data;
  }
}
