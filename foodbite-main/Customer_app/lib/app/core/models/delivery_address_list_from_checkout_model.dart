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

class DeliveryAddressListFromCheckoutModel {
  List<AddressListConfigModel>? list;
  int? total;
  String? mode;
  double? courage;

  DeliveryAddressListFromCheckoutModel({this.list, this.total, this.mode, this.courage});

  DeliveryAddressListFromCheckoutModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <AddressListConfigModel>[];
      json['list'].forEach((v) {
        list!.add(AddressListConfigModel.fromJson(v));
      });
    }
    if (json['total'] != null && json['total'] != '') {
      total = int.parse(json['total'].toString());
    } else {
      total = 0;
    }
    if (json['mode'] != null && json['mode'] != '') {
      mode = json['mode'];
    } else {
      mode = 'km';
    }
    if (json['courage'] != null && json['courage'] != '') {
      courage = double.parse(json['courage'].toString());
    } else {
      courage = 50.0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['mode'] = mode;
    data['courage'] = courage;
    return data;
  }
}

class AddressListConfigModel {
  int? title;
  String? receiverName;
  String? countryCode;
  String? receiverContact;
  String? flatHouse;
  String? locality;
  String? landmark;
  LocationCoordinates? location;
  String? distance;
  bool? willShow = true;
  String? id;

  AddressListConfigModel({this.title, this.receiverName, this.countryCode, this.receiverContact, this.flatHouse, this.locality, this.landmark, this.location, this.distance, this.id});

  AddressListConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['title'] != null && json['title'] != '') {
      title = int.parse(json['title'].toString());
    } else {
      title = 0;
    }
    receiverName = json['receiverName'];
    countryCode = json['countryCode'].toString();
    receiverContact = json['receiverContact'];
    flatHouse = json['flatHouse'];
    locality = json['locality'];
    landmark = json['landmark'];
    location = json['location'] != null ? LocationCoordinates.fromJson(json['location']) : null;
    if (json['distance'] != null && json['distance'] != '') {
      distance = double.parse(json['distance'].toString()).toStringAsFixed(2);
    } else {
      distance = '0.0';
    }
    if (json['willShow'] != null && json['willShow'] != '') {
      willShow = json['willShow'];
    } else {
      willShow = true;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['receiverName'] = receiverName;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    data['flatHouse'] = flatHouse;
    data['locality'] = locality;
    data['landmark'] = landmark;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['distance'] = distance;
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
