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

class ManageDeliverymanInitialResponseModel {
  List<DeliverymanVehicleConfigModel>? vehicles;
  DeliverymanInitialInfo? info;
  final String locale;
  ManageDeliverymanInitialResponseModel({this.vehicles, this.info, required this.locale});

  ManageDeliverymanInitialResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['vehicles'] != null) {
      vehicles = <DeliverymanVehicleConfigModel>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(DeliverymanVehicleConfigModel.fromJson(v, locale));
      });
    }
    info = json['info'] != null ? DeliverymanInitialInfo.fromJson(json['info']) : null;
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

class DeliverymanInitialInfo {
  LocationCoordinates? location;
  String? name;
  String? city;
  String? locality;
  String? id;

  DeliverymanInitialInfo({this.location, this.name, this.city, this.locality, this.id});

  DeliverymanInitialInfo.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? LocationCoordinates.fromJson(json['location']) : null;
    name = json['name'];
    city = json['city'];
    locality = json['locality'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['name'] = name;
    data['city'] = city;
    data['locality'] = locality;
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
