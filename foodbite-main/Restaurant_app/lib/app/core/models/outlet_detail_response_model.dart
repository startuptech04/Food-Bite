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

import 'package:vendor/app/core/models/outlet_cities_response_model.dart';
import 'package:vendor/app/core/models/outlet_license_response_model.dart';
import 'package:vendor/app/core/models/outlet_localities_response_model.dart';
import 'package:vendor/app/core/models/translations/outlet_form_translation.dart';

class OutletDetailResponseModel {
  OutletDetailConfigModel? result;
  List<OutletCitiesResponseModel>? cities;
  List<OutletLicenseResponseModel>? licenses;
  List<OutletLocalitiesResponseModel>? localities;
  bool? success;
  final String locale;
  OutletDetailResponseModel({this.result, this.cities, this.licenses, this.localities, this.success, required this.locale});

  OutletDetailResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    result = json['result'] != null ? OutletDetailConfigModel.fromJson(json['result'], locale) : null;
    if (json['cities'] != null) {
      cities = <OutletCitiesResponseModel>[];
      json['cities'].forEach((v) {
        cities!.add(OutletCitiesResponseModel.fromJson(v, locale));
      });
    }
    if (json['licenses'] != null) {
      licenses = <OutletLicenseResponseModel>[];
      json['licenses'].forEach((v) {
        licenses!.add(OutletLicenseResponseModel.fromJson(v, locale));
      });
    }
    if (json['localities'] != null) {
      localities = <OutletLocalitiesResponseModel>[];
      json['localities'].forEach((v) {
        localities!.add(OutletLocalitiesResponseModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    if (licenses != null) {
      data['licenses'] = licenses!.map((v) => v.toJson()).toList();
    }
    if (localities != null) {
      data['localities'] = localities!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class OutletDetailConfigModel {
  String? name;
  String? address;
  String? shortDescription;
  List<CuisineConfigModel>? cuisine;
  String? logo;
  String? cover;
  String? city;
  String? locality;
  LocationCoordinates? location;
  String? approxDeliveryTime;
  double? dishPriceForTwo;
  bool? takeAway;
  List<OutletFormTranslations>? translations;
  bool? acceptScheduleDelivery;
  bool? acceptHomeDelivery;
  double? minOrderAmount;
  String? socialFacebook;
  String? socialInstagram;
  String? socialX;
  String? socialYoutube;
  String? socialLinkedIn;
  String? socialPinterest;
  String? license;
  String? licenseId;
  List<RestaurantFacilitiesConfigModel>? restaurantfacilities;
  List<RestaurantTypeConfigModel>? restauranttypes;
  String? id;
  final String locale;
  OutletDetailConfigModel({
    this.name,
    this.address,
    this.shortDescription,
    this.cuisine,
    this.logo,
    this.cover,
    this.city,
    this.locality,
    this.location,
    this.approxDeliveryTime,
    this.dishPriceForTwo,
    this.takeAway,
    this.translations,
    this.acceptScheduleDelivery,
    this.acceptHomeDelivery,
    this.minOrderAmount,
    this.socialFacebook,
    this.socialInstagram,
    this.socialX,
    this.socialYoutube,
    this.socialLinkedIn,
    this.socialPinterest,
    this.license,
    this.licenseId,
    this.restaurantfacilities,
    this.restauranttypes,
    this.id,
    required this.locale,
  });

  OutletDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    address = json['address'];
    shortDescription = json['shortDescription'];
    if (json['cuisine'] != null) {
      cuisine = <CuisineConfigModel>[];
      json['cuisine'].forEach((v) {
        cuisine!.add(CuisineConfigModel.fromJson(v, locale));
      });
    }
    logo = json['logo'];
    cover = json['cover'];
    city = json['city'];
    locality = json['locality'];
    location = json['location'] != null ? LocationCoordinates.fromJson(json['location']) : null;
    approxDeliveryTime = json['approxDeliveryTime'];
    if (json['dishPriceForTwo'] != null && json['dishPriceForTwo'] != '') {
      dishPriceForTwo = double.parse(json['dishPriceForTwo'].toString());
    } else {
      dishPriceForTwo = 0;
    }
    takeAway = json['takeAway'];
    if (json['translations'] != null) {
      translations = <OutletFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(OutletFormTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            name = translations![localeIndex].title!;
          }
          if (translations![localeIndex].address!.isNotEmpty) {
            address = translations![localeIndex].address!;
          }
          if (translations![localeIndex].shortDescription!.isNotEmpty) {
            shortDescription = translations![localeIndex].shortDescription!;
          }
        }
      }
    } else {
      translations = [];
    }
    acceptScheduleDelivery = json['acceptScheduleDelivery'];
    acceptHomeDelivery = json['acceptHomeDelivery'];
    if (json['minOrderAmount'] != null && json['minOrderAmount'] != '') {
      minOrderAmount = double.parse(json['minOrderAmount'].toString());
    } else {
      minOrderAmount = 0;
    }
    if (json['socialFacebook'] != null && json['socialFacebook'] != '') {
      socialFacebook = json['socialFacebook'];
    } else {
      socialFacebook = '';
    }
    if (json['socialInstagram'] != null && json['socialInstagram'] != '') {
      socialInstagram = json['socialInstagram'];
    } else {
      socialInstagram = '';
    }
    if (json['socialX'] != null && json['socialX'] != '') {
      socialX = json['socialX'];
    } else {
      socialX = '';
    }
    if (json['socialYoutube'] != null && json['socialYoutube'] != '') {
      socialYoutube = json['socialYoutube'];
    } else {
      socialYoutube = '';
    }
    if (json['socialLinkedIn'] != null && json['socialLinkedIn'] != '') {
      socialLinkedIn = json['socialLinkedIn'];
    } else {
      socialLinkedIn = '';
    }
    if (json['socialPinterest'] != null && json['socialPinterest'] != '') {
      socialPinterest = json['socialPinterest'];
    } else {
      socialPinterest = '';
    }
    license = json['license'];
    licenseId = json['licenseId'];
    if (json['restaurantfacilities'] != null) {
      restaurantfacilities = <RestaurantFacilitiesConfigModel>[];
      json['restaurantfacilities'].forEach((v) {
        restaurantfacilities!.add(RestaurantFacilitiesConfigModel.fromJson(v, locale));
      });
    }
    if (json['restauranttypes'] != null) {
      restauranttypes = <RestaurantTypeConfigModel>[];
      json['restauranttypes'].forEach((v) {
        restauranttypes!.add(RestaurantTypeConfigModel.fromJson(v, locale));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['shortDescription'] = shortDescription;
    if (cuisine != null) {
      data['cuisine'] = cuisine!.map((v) => v.toJson()).toList();
    }
    data['logo'] = logo;
    data['cover'] = cover;
    data['city'] = city;
    data['locality'] = locality;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['approxDeliveryTime'] = approxDeliveryTime;
    data['dishPriceForTwo'] = dishPriceForTwo;
    data['takeAway'] = takeAway;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['acceptScheduleDelivery'] = acceptScheduleDelivery;
    data['acceptHomeDelivery'] = acceptHomeDelivery;
    data['minOrderAmount'] = minOrderAmount;
    data['socialFacebook'] = socialFacebook;
    data['socialInstagram'] = socialInstagram;
    data['socialX'] = socialX;
    data['socialYoutube'] = socialYoutube;
    data['socialLinkedIn'] = socialLinkedIn;
    data['socialPinterest'] = socialPinterest;
    data['license'] = license;
    data['licenseId'] = licenseId;
    if (restaurantfacilities != null) {
      data['restaurantfacilities'] = restaurantfacilities!.map((v) => v.toJson()).toList();
    }
    if (restauranttypes != null) {
      data['restauranttypes'] = restauranttypes!.map((v) => v.toJson()).toList();
    }
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

class CuisineConfigModel {
  String? name;
  List<CuisineTranslations>? translations;
  String? id;
  final String locale;
  CuisineConfigModel({this.name, this.translations, this.id, required this.locale});

  CuisineConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CuisineTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CuisineTranslations.fromJson(v));
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
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class CuisineTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  CuisineTranslations({this.name, this.code, this.nativeName, this.value});

  CuisineTranslations.fromJson(Map<String, dynamic> json) {
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

class RestaurantFacilitiesConfigModel {
  String? name;
  List<RestaurantFacilitiesTranslations>? translations;
  String? id;
  final String locale;
  RestaurantFacilitiesConfigModel({this.name, this.translations, this.id, required this.locale});

  RestaurantFacilitiesConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <RestaurantFacilitiesTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(RestaurantFacilitiesTranslations.fromJson(v));
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
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class RestaurantFacilitiesTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  RestaurantFacilitiesTranslations({this.name, this.code, this.nativeName, this.value});

  RestaurantFacilitiesTranslations.fromJson(Map<String, dynamic> json) {
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

class RestaurantTypeConfigModel {
  String? name;
  List<RestaurantTypeTranslations>? translations;
  String? id;
  final String locale;
  RestaurantTypeConfigModel({this.name, this.translations, this.id, required this.locale});

  RestaurantTypeConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <RestaurantTypeTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(RestaurantTypeTranslations.fromJson(v));
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
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class RestaurantTypeTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  RestaurantTypeTranslations({this.name, this.code, this.nativeName, this.value});

  RestaurantTypeTranslations.fromJson(Map<String, dynamic> json) {
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
