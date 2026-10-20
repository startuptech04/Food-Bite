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

import 'package:intl/intl.dart';

class DriverProfileInfoResponseModel {
  DriverInfoConfigModel? info;
  DriverExtraInfoConfigModel? driver;
  List<VehicleInfoConfigModel>? vehicleList;
  bool? success;
  final String locale;
  DriverProfileInfoResponseModel({this.info, this.driver, this.vehicleList, this.success, required this.locale});

  DriverProfileInfoResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    info = json['info'] != null ? DriverInfoConfigModel.fromJson(json['info']) : null;
    driver = json['driver'] != null ? DriverExtraInfoConfigModel.fromJson(json['driver'], locale) : null;
    if (json['vehicleList'] != null) {
      vehicleList = <VehicleInfoConfigModel>[];
      json['vehicleList'].forEach((v) {
        vehicleList!.add(VehicleInfoConfigModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (vehicleList != null) {
      data['vehicleList'] = vehicleList!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class DriverInfoConfigModel {
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  bool? isEmailVerified;
  String? image;
  String? countryCode;
  String? mobile;
  bool? isMobileVerified;
  String? gender;
  String? id;

  DriverInfoConfigModel({this.firstName, this.lastName, this.email, this.role, this.isEmailVerified, this.image, this.countryCode, this.mobile, this.isMobileVerified, this.gender, this.id});

  DriverInfoConfigModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    role = json['role'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    mobile = json['mobile'];
    isMobileVerified = json['isMobileVerified'];
    gender = json['gender'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['role'] = role;
    data['isEmailVerified'] = isEmailVerified;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['isMobileVerified'] = isMobileVerified;
    data['gender'] = gender;
    data['id'] = id;
    return data;
  }
}

class DriverExtraInfoConfigModel {
  CityInfoConfigModel? city;
  LocalityInfoConfigModel? locality;
  VehicleInfoConfigModel? vehicle;
  String? type;
  String? identity;
  String? identityNumber;
  String? identityProof;
  String? drivingLicense;
  String? dob;
  String? id;
  final String locale;

  DriverExtraInfoConfigModel({this.city, this.locality, this.vehicle, this.type, this.identity, this.identityNumber, this.identityProof, this.drivingLicense, this.dob, this.id, required this.locale});

  DriverExtraInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    city = json['city'] != null ? CityInfoConfigModel.fromJson(json['city'], locale) : null;
    locality = json['locality'] != null ? LocalityInfoConfigModel.fromJson(json['locality'], locale) : null;
    vehicle = json['vehicle'] != null ? VehicleInfoConfigModel.fromJson(json['vehicle'], locale) : null;
    type = json['type'];
    identity = json['identity'];
    identityNumber = json['identityNumber'];
    identityProof = json['identityProof'];
    drivingLicense = json['drivingLicense'];
    if (json['dob'] != null && json['dob'] != '') {
      DateTime dateTime = DateTime.parse(json['dob']);
      String formattedDate = DateFormat('d MMMM yyyy', locale).format(dateTime);
      dob = formattedDate;
    } else {
      dob = '15 July 1997';
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (locality != null) {
      data['locality'] = locality!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    data['type'] = type;
    data['identity'] = identity;
    data['identityNumber'] = identityNumber;
    data['identityProof'] = identityProof;
    data['drivingLicense'] = drivingLicense;
    data['dob'] = dob;
    data['id'] = id;
    return data;
  }
}

class CityInfoConfigModel {
  String? id;
  String? name;
  List<CommanTranslations>? translations;
  final String locale;

  CityInfoConfigModel({this.id, this.name, this.translations, required this.locale});

  CityInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CommanTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CommanTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            name = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocalityInfoConfigModel {
  String? id;
  String? name;
  List<CommanTranslations>? translations;
  final String locale;

  LocalityInfoConfigModel({this.id, this.name, this.translations, required this.locale});

  LocalityInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CommanTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CommanTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            name = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleInfoConfigModel {
  String? id;
  String? name;
  List<CommanTranslations>? translations;
  final String locale;

  VehicleInfoConfigModel({this.id, this.name, this.translations, required this.locale});

  VehicleInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CommanTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CommanTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            name = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommanTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  CommanTranslations({this.name, this.code, this.nativeName, this.value});

  CommanTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['value'] = value;
    return data;
  }
}
