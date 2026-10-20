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

class FoodCampaignListModel {
  List<FoodCampaignResultModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  final String locale;
  FoodCampaignListModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, required this.locale});

  FoodCampaignListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <FoodCampaignResultModel>[];
      json['results'].forEach((v) {
        results!.add(FoodCampaignResultModel.fromJson(v, locale));
      });
    }
    page = int.parse(json['page'].toString());
    limit = int.parse(json['limit'].toString());
    totalPages = int.parse(json['totalPages'].toString());
    totalResults = int.parse(json['totalResults'].toString());
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
    return data;
  }
}

class FoodCampaignResultModel {
  String? title;
  String? shortDescription;
  CityModel? city;
  List<String>? foods;
  String? image;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  List<FoodCampaignTranslations>? translations;
  bool? status;
  String? id;
  final String locale;
  FoodCampaignResultModel({this.title, this.shortDescription, this.city, this.foods, this.image, this.startDate, this.endDate, this.startTime, this.endTime, this.translations, this.status, this.id, required this.locale});

  FoodCampaignResultModel.fromJson(Map<String, dynamic> json, this.locale) {
    title = json['title'];
    shortDescription = json['shortDescription'];
    city = json['city'] != null ? CityModel.fromJson(json['city'], locale) : null;
    foods = json['foods'].cast<String>();
    image = json['image'];
    if (json['startDate'] != null && json['startDate'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['startDate']);
      var inputDate = DateTime.parse(parseDate.toString());
      startDate = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      startDate = '-';
    }
    if (json['endDate'] != null && json['endDate'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['endDate']);
      var inputDate = DateTime.parse(parseDate.toString());
      endDate = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      endDate = '-';
    }
    if (json['startTime'] != null && json['startTime'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm").parse("2024-01-01 ${json['startTime']}");
      var inputDate = DateTime.parse(parseDate.toString());
      startTime = DateFormat('hh:mm a', locale).format(inputDate);
    } else {
      startTime = '-';
    }
    if (json['endTime'] != null && json['endTime'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm").parse("2024-01-01 ${json['endTime']}");
      var inputDate = DateTime.parse(parseDate.toString());
      endTime = DateFormat('hh:mm a', locale).format(inputDate);
    } else {
      endTime = '-';
    }
    if (json['translations'] != null) {
      translations = <FoodCampaignTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(FoodCampaignTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            title = translations![localeIndex].title!;
          }
          if (translations![localeIndex].shortDescription!.isNotEmpty) {
            shortDescription = translations![localeIndex].shortDescription!;
          }
        }
      }
    } else {
      translations = [];
    }
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['shortDescription'] = shortDescription;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['foods'] = foods;
    data['image'] = image;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class CityModel {
  Location? location;
  String? name;
  String? image;
  List<Translations>? translations;
  bool? status;
  String? slug;
  String? id;
  final String locale;
  CityModel({this.location, this.name, this.image, this.translations, this.status, this.slug, this.id, required this.locale});

  CityModel.fromJson(Map<String, dynamic> json, this.locale) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    name = json['name'];
    image = json['image'];
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
    status = json['status'];
    slug = json['slug'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['name'] = name;
    data['image'] = image;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['slug'] = slug;
    data['id'] = id;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
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

class FoodCampaignTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  FoodCampaignTranslations({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  FoodCampaignTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
    shortDescription = json['shortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    data['shortDescription'] = shortDescription;
    return data;
  }
}
