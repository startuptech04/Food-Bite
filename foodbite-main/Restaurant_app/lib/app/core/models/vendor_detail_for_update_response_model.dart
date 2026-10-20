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

import 'package:vendor/app/core/models/translations/edit_restaurant_form_translation.dart';

class VendorDetailForUpdateResponseModel {
  VendorDetailConfigModel? details;
  List<RestaurantFoodLicenseConfigModel>? license;
  bool? success;
  final String locale;
  VendorDetailForUpdateResponseModel({this.details, this.license, this.success, required this.locale});

  VendorDetailForUpdateResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    details = json['details'] != null ? VendorDetailConfigModel.fromJson(json['details'], locale) : null;
    if (json['license'] != null) {
      license = <RestaurantFoodLicenseConfigModel>[];
      json['license'].forEach((v) {
        license!.add(RestaurantFoodLicenseConfigModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (license != null) {
      data['license'] = license!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class VendorDetailConfigModel {
  String? id;
  String? name;
  String? address;
  List<RestaurantCuisineConfigModel>? cuisine;
  String? logo;
  String? cover;
  String? approxDeliveryTime;
  List<EditRestaurantFormTranslations>? translations;
  bool? pureVeg;
  String? license;
  String? licenseId;
  bool? takeAway;
  bool? acceptHomeDelivery;
  bool? acceptScheduleDelivery;
  String? shortDescription;
  List<RestaurantTypeConfigModel>? restauranttypes;
  List<RestaurantFacilitiesConfigModel>? restaurantfacilities;
  double? dishPriceForTwo;
  double? minOrderAmount;
  String? socialFacebook;
  String? socialInstagram;
  String? socialX;
  String? socialYoutube;
  String? socialLinkedIn;
  String? socialPinterest;
  final String locale;
  VendorDetailConfigModel({
    this.id,
    this.name,
    this.address,
    this.cuisine,
    this.logo,
    this.cover,
    this.approxDeliveryTime,
    this.translations,
    this.pureVeg,
    this.license,
    this.licenseId,
    this.takeAway,
    this.acceptHomeDelivery,
    this.acceptScheduleDelivery,
    this.shortDescription,
    this.restauranttypes,
    this.restaurantfacilities,
    this.dishPriceForTwo,
    this.minOrderAmount,
    this.socialFacebook,
    this.socialInstagram,
    this.socialX,
    this.socialYoutube,
    this.socialLinkedIn,
    this.socialPinterest,
    required this.locale,
  });

  VendorDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    if (json['cuisine'] != null) {
      cuisine = <RestaurantCuisineConfigModel>[];
      json['cuisine'].forEach((v) {
        cuisine!.add(RestaurantCuisineConfigModel.fromJson(v, locale));
      });
    }
    logo = json['logo'];
    cover = json['cover'];
    approxDeliveryTime = json['approxDeliveryTime'];
    if (json['translations'] != null) {
      translations = <EditRestaurantFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(EditRestaurantFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
    pureVeg = json['pureVeg'];
    license = json['license'];
    licenseId = json['licenseId'];
    takeAway = json['takeAway'];
    acceptHomeDelivery = json['acceptHomeDelivery'];
    acceptScheduleDelivery = json['acceptScheduleDelivery'];
    shortDescription = json['shortDescription'];
    if (json['restauranttypes'] != null) {
      restauranttypes = <RestaurantTypeConfigModel>[];
      json['restauranttypes'].forEach((v) {
        restauranttypes!.add(RestaurantTypeConfigModel.fromJson(v, locale));
      });
    }
    if (json['restaurantfacilities'] != null) {
      restaurantfacilities = <RestaurantFacilitiesConfigModel>[];
      json['restaurantfacilities'].forEach((v) {
        restaurantfacilities!.add(RestaurantFacilitiesConfigModel.fromJson(v, locale));
      });
    }
    if (json['dishPriceForTwo'] != null && json['dishPriceForTwo'] != '') {
      dishPriceForTwo = double.parse(json['dishPriceForTwo'].toString());
    } else {
      dishPriceForTwo = 0;
    }
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    if (cuisine != null) {
      data['cuisine'] = cuisine!.map((v) => v.toJson()).toList();
    }
    data['logo'] = logo;
    data['cover'] = cover;
    data['approxDeliveryTime'] = approxDeliveryTime;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['pureVeg'] = pureVeg;
    data['license'] = license;
    data['licenseId'] = licenseId;
    data['takeAway'] = takeAway;
    data['acceptHomeDelivery'] = acceptHomeDelivery;
    data['acceptScheduleDelivery'] = acceptScheduleDelivery;
    data['shortDescription'] = shortDescription;
    if (restauranttypes != null) {
      data['restauranttypes'] = restauranttypes!.map((v) => v.toJson()).toList();
    }
    if (restaurantfacilities != null) {
      data['restaurantfacilities'] = restaurantfacilities!.map((v) => v.toJson()).toList();
    }
    data['dishPriceForTwo'] = dishPriceForTwo;
    data['minOrderAmount'] = minOrderAmount;
    data['socialFacebook'] = socialFacebook;
    data['socialInstagram'] = socialInstagram;
    data['socialX'] = socialX;
    data['socialYoutube'] = socialYoutube;
    data['socialLinkedIn'] = socialLinkedIn;
    data['socialPinterest'] = socialPinterest;
    return data;
  }
}

class RestaurantCuisineConfigModel {
  String? name;
  List<RestaurantCuisineTranslations>? translations;
  String? id;
  final String locale;
  RestaurantCuisineConfigModel({this.name, this.translations, this.id, required this.locale});

  RestaurantCuisineConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <RestaurantCuisineTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(RestaurantCuisineTranslations.fromJson(v));
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

class RestaurantCuisineTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  RestaurantCuisineTranslations({this.name, this.code, this.nativeName, this.value});

  RestaurantCuisineTranslations.fromJson(Map<String, dynamic> json) {
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

class RestaurantFoodLicenseConfigModel {
  String? name;
  List<RestaurantFoodLicenseTranslations>? translations;
  String? id;
  final String locale;
  RestaurantFoodLicenseConfigModel({this.name, this.translations, this.id, required this.locale});

  RestaurantFoodLicenseConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <RestaurantFoodLicenseTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(RestaurantFoodLicenseTranslations.fromJson(v));
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

class RestaurantFoodLicenseTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  RestaurantFoodLicenseTranslations({this.name, this.code, this.nativeName, this.value});

  RestaurantFoodLicenseTranslations.fromJson(Map<String, dynamic> json) {
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
