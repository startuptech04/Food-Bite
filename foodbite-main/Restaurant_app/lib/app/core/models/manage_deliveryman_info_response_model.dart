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

import 'package:vendor/app/core/models/deliveryman_vehicle_response_model.dart';

class ManageDeliverymanInfoResponseModel {
  List<DeliverymanVehicleConfigModel>? vehicles;
  DeliverymanInfoConfigModel? info;
  final String locale;
  ManageDeliverymanInfoResponseModel({this.vehicles, this.info, required this.locale});

  ManageDeliverymanInfoResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['vehicles'] != null) {
      vehicles = <DeliverymanVehicleConfigModel>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(DeliverymanVehicleConfigModel.fromJson(v, locale));
      });
    }
    info = json['info'] != null ? DeliverymanInfoConfigModel.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    if (info != null) {
      data['info'] = info!.toJson();
    }
    return data;
  }
}

class DeliverymanInfoConfigModel {
  String? city;
  String? locality;
  String? restaurant;
  LocationCoordinates? location;
  String? vehicle;
  String? identity;
  String? identityNumber;
  String? identityProof;
  String? drivingLicense;
  String? age;
  String? dob;
  String? id;

  DeliverymanInfoConfigModel({this.city, this.locality, this.restaurant, this.location, this.vehicle, this.identity, this.identityNumber, this.identityProof, this.drivingLicense, this.age, this.dob, this.id});

  DeliverymanInfoConfigModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    locality = json['locality'];
    restaurant = json['restaurant'];
    location = json['location'] != null ? LocationCoordinates.fromJson(json['location']) : null;
    vehicle = json['vehicle'];
    identity = json['identity'];
    identityNumber = json['identityNumber'];
    identityProof = json['identityProof'];
    drivingLicense = json['drivingLicense'];
    age = json['age'].toString();
    dob = json['dob'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['locality'] = locality;
    data['restaurant'] = restaurant;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['vehicle'] = vehicle;
    data['identity'] = identity;
    data['identityNumber'] = identityNumber;
    data['identityProof'] = identityProof;
    data['drivingLicense'] = drivingLicense;
    data['age'] = age;
    data['dob'] = dob;
    data['id'] = id;
    return data;
  }
}

class LocationCoordinates {
  String? type;
  List<double>? coordinates;

  LocationCoordinates({this.type, this.coordinates});

  LocationCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null && json['coordinates'] is List) {
      coordinates = List<double>.from(json['coordinates'].map((x) => x.toDouble()));
    } else {
      coordinates = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
