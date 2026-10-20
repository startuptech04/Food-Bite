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

class AccountUpdateMobileNumberAfterVerificationRequestModel {
  String? countryCode;
  int? mobileNumber;
  String? verificationId;

  AccountUpdateMobileNumberAfterVerificationRequestModel({this.countryCode, this.mobileNumber, this.verificationId});

  AccountUpdateMobileNumberAfterVerificationRequestModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    mobileNumber = json['mobileNumber'];
    verificationId = json['verificationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['mobileNumber'] = mobileNumber;
    data['verificationId'] = verificationId;
    return data;
  }
}
