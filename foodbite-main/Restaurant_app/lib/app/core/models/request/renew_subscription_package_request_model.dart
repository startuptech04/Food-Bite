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

class RenewSubscriptionPackageRequestModel {
  String? user;
  String? payment;
  String? subscriber;
  String? packageId;

  RenewSubscriptionPackageRequestModel({this.user, this.payment, this.subscriber, this.packageId});

  RenewSubscriptionPackageRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    payment = json['payment'];
    subscriber = json['subscriber'];
    packageId = json['packageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['payment'] = payment;
    data['subscriber'] = subscriber;
    data['packageId'] = packageId;
    return data;
  }
}
