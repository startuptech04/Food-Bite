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

class ManageDeliverymanCreateProfileRequestModel {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? mobile;
  String? image;
  String? city;
  String? restaurant;
  String? locality;
  String? vehicle;
  double? latitude;
  double? longitude;
  String? identity;
  String? identityNumber;
  String? identityProof;
  String? drivingLicense;
  String? age;
  String? dob;

  ManageDeliverymanCreateProfileRequestModel(
      {this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.countryCode,
      this.mobile,
      this.image,
      this.city,
      this.restaurant,
      this.locality,
      this.vehicle,
      this.latitude,
      this.longitude,
      this.identity,
      this.identityNumber,
      this.identityProof,
      this.drivingLicense,
      this.age,
      this.dob});

  ManageDeliverymanCreateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    image = json['image'];
    city = json['city'];
    restaurant = json['restaurant'];
    locality = json['locality'];
    vehicle = json['vehicle'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    identity = json['identity'];
    identityNumber = json['identityNumber'];
    identityProof = json['identityProof'];
    drivingLicense = json['drivingLicense'];
    age = json['age'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['image'] = image;
    data['city'] = city;
    data['restaurant'] = restaurant;
    data['locality'] = locality;
    data['vehicle'] = vehicle;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['identity'] = identity;
    data['identityNumber'] = identityNumber;
    data['identityProof'] = identityProof;
    data['drivingLicense'] = drivingLicense;
    data['age'] = age;
    data['dob'] = dob;
    return data;
  }
}
