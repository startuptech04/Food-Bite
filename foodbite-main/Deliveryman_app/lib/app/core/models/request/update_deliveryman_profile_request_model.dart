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

class UpdateDeliverymanProfileRequestModel {
  String? firstName;
  String? lastName;
  String? image;
  String? gender;
  String? identity;
  String? identityNumber;
  String? identityProof;
  String? drivingLicense;
  String? vehicle;

  UpdateDeliverymanProfileRequestModel({this.firstName, this.lastName, this.image, this.gender, this.identity, this.identityNumber, this.identityProof, this.drivingLicense, this.vehicle});

  UpdateDeliverymanProfileRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    gender = json['gender'];
    identity = json['identity'];
    identityNumber = json['identityNumber'];
    identityProof = json['identityProof'];
    drivingLicense = json['drivingLicense'];
    vehicle = json['vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['gender'] = gender;
    data['identity'] = identity;
    data['identityNumber'] = identityNumber;
    data['identityProof'] = identityProof;
    data['drivingLicense'] = drivingLicense;
    data['vehicle'] = vehicle;
    return data;
  }
}
