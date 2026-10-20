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

class UserCancelTiffinSubscriptionPackageRequestModel {
  String? id;
  String? user;
  String? cancellationId;

  UserCancelTiffinSubscriptionPackageRequestModel({this.id, this.user, this.cancellationId});

  UserCancelTiffinSubscriptionPackageRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    cancellationId = json['cancellationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['cancellationId'] = cancellationId;
    return data;
  }
}
