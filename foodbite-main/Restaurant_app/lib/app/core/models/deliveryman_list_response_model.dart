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

class DeliverymanListResponseModel {
  List<DeliverymanConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  DeliverymanListResponseModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  DeliverymanListResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <DeliverymanConfigModel>[];
      json['results'].forEach((v) {
        results!.add(DeliverymanConfigModel.fromJson(v, locale));
      });
    }
    if (json['page'] != null && json['page'] != '') {
      page = int.parse(json['page'].toString());
    } else {
      page = 0;
    }
    if (json['limit'] != null && json['limit'] != '') {
      limit = int.parse(json['limit'].toString());
    } else {
      limit = 0;
    }
    if (json['totalPages'] != null && json['totalPages'] != '') {
      totalPages = int.parse(json['totalPages'].toString());
    } else {
      totalPages = 0;
    }
    if (json['totalResults'] != null && json['totalResults'] != '') {
      totalResults = int.parse(json['totalResults'].toString());
    } else {
      totalResults = 0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class DeliverymanConfigModel {
  CityInfoConfigModel? city;
  LocalityInfoConfigModel? locality;
  String? type;
  bool? isBlocked;
  bool? activeStatus;
  int? orderHandling;
  double? rating;
  bool? status;
  String? id;
  String? totalRating;
  DeliverymanInfoConfigModel? driverInfo;
  OfflineReasonConfigModel? offline;
  final String locale;
  DeliverymanConfigModel({this.city, this.locality, this.type, this.isBlocked, this.activeStatus, this.orderHandling, this.rating, this.status, this.id, this.totalRating, this.driverInfo, this.offline, required this.locale});

  DeliverymanConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    city = json['city'] != null ? CityInfoConfigModel.fromJson(json['city'], locale) : null;
    locality = json['locality'] != null ? LocalityInfoConfigModel.fromJson(json['locality'], locale) : null;
    type = json['type'];
    isBlocked = json['isBlocked'];
    activeStatus = json['activeStatus'];
    if (json['orderHandling'] != null && json['orderHandling'] != '') {
      orderHandling = int.parse(json['orderHandling'].toString());
    } else {
      orderHandling = 0;
    }
    if (json['rating'] != null && json['rating'] != '') {
      rating = double.parse(json['rating'].toString());
    } else {
      rating = 0.0;
    }
    status = json['status'];
    id = json['id'];
    if (json['totalRating'] != null && json['totalRating'] != '') {
      int ratingCount = int.parse(json['totalRating'].toString());
      String formatNumber(num number) {
        if (number >= 1000000000) {
          return '${(number / 1000000000).toStringAsFixed(1)}B';
        } else if (number >= 1000000) {
          return '${(number / 1000000).toStringAsFixed(1)}M';
        } else if (number >= 1000) {
          return '${(number / 1000).toStringAsFixed(1)}K';
        } else {
          return number.toString();
        }
      }

      totalRating = formatNumber(ratingCount);
    } else {
      totalRating = '0';
    }
    driverInfo = json['driverInfo'] != null ? DeliverymanInfoConfigModel.fromJson(json['driverInfo']) : null;
    offline = json['offline'] != null ? OfflineReasonConfigModel.fromJson(json['offline'], locale) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (locality != null) {
      data['locality'] = locality!.toJson();
    }
    data['type'] = type;
    data['isBlocked'] = isBlocked;
    data['activeStatus'] = activeStatus;
    data['orderHandling'] = orderHandling;
    data['rating'] = rating;
    data['status'] = status;
    data['id'] = id;
    data['totalRating'] = totalRating;
    if (driverInfo != null) {
      data['driverInfo'] = driverInfo!.toJson();
    }
    if (offline != null) {
      data['offline'] = offline!.toJson();
    }
    return data;
  }
}

class CityInfoConfigModel {
  String? id;
  String? name;
  List<Translations>? translations;
  final String locale;
  CityInfoConfigModel({this.id, this.name, this.translations, required this.locale});

  CityInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
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
  List<Translations>? translations;
  final String locale;
  LocalityInfoConfigModel({this.id, this.name, this.translations, required this.locale});

  LocalityInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
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

class OfflineReasonConfigModel {
  String? id;
  String? name;
  List<Translations>? translations;
  final String locale;
  OfflineReasonConfigModel({this.id, this.name, this.translations, required this.locale});

  OfflineReasonConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
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

class Translations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  Translations({this.name, this.code, this.nativeName, this.value});

  Translations.fromJson(Map<String, dynamic> json) {
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

class DeliverymanInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;
  String? countryCode;
  String? contactNumber;
  String? contactEmail;

  DeliverymanInfoConfigModel({this.id, this.firstName, this.lastName, this.image, this.countryCode, this.contactNumber, this.contactEmail});

  DeliverymanInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    countryCode = json['countryCode'].toString();
    contactNumber = json['contactNumber'];
    contactEmail = json['contactEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['countryCode'] = countryCode;
    data['contactNumber'] = contactNumber;
    data['contactEmail'] = contactEmail;
    return data;
  }
}
