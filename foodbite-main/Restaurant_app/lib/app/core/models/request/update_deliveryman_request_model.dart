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

class UpdateDeliverymanRequestModel {
  String? city;
  String? locality;
  String? restaurant;
  String? age;
  String? identity;
  String? identityNumber;
  String? identityProof;
  String? drivingLicense;
  String? dob;
  String? vehicle;
  String? locationType;
  double? longitude;
  double? latitude;
  String? type;

  UpdateDeliverymanRequestModel({
    this.city,
    this.locality,
    this.restaurant,
    this.age,
    this.identity,
    this.identityNumber,
    this.identityProof,
    this.drivingLicense,
    this.dob,
    this.vehicle,
    this.locationType,
    this.longitude,
    this.latitude,
    this.type,
  });

  UpdateDeliverymanRequestModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    locality = json['locality'];
    restaurant = json['restaurant'];
    age = json['age'];
    identity = json['identity'];
    identityNumber = json['identityNumber'];
    identityProof = json['identityProof'];
    drivingLicense = json['drivingLicense'];
    dob = json['dob'];
    vehicle = json['vehicle'];
    locationType = json['locationType'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['locality'] = locality;
    data['restaurant'] = restaurant;
    data['age'] = age;
    data['identity'] = identity;
    data['identityNumber'] = identityNumber;
    data['identityProof'] = identityProof;
    data['drivingLicense'] = drivingLicense;
    data['dob'] = dob;
    data['vehicle'] = vehicle;
    data['locationType'] = locationType;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['type'] = type;
    return data;
  }
}
