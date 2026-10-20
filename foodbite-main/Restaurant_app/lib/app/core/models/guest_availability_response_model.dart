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

class GuestAvailabilityResponseModel {
  GuestAvailabilityResult? result;
  bool? success;

  GuestAvailabilityResponseModel({this.result, this.success});

  GuestAvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? GuestAvailabilityResult.fromJson(json['result']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class GuestAvailabilityResult {
  List<int>? guestAvailability;
  String? id;

  GuestAvailabilityResult({this.guestAvailability, this.id});

  GuestAvailabilityResult.fromJson(Map<String, dynamic> json) {
    guestAvailability = json['guestAvailability'].cast<int>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['guestAvailability'] = guestAvailability;
    data['id'] = id;
    return data;
  }
}
