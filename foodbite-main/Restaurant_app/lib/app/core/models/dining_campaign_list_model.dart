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

class DiningCampaignListModel {
  List<DiningCampaignConfigModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  DiningCampaignListModel({this.results, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  DiningCampaignListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <DiningCampaignConfigModel>[];
      json['results'].forEach((v) {
        results!.add(DiningCampaignConfigModel.fromJson(v, locale));
      });
    }
    page = int.parse(json['page'].toString());
    limit = int.parse(json['limit'].toString());
    totalPages = int.parse(json['totalPages'].toString());
    totalResults = int.parse(json['totalResults'].toString());
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

class DiningCampaignConfigModel {
  String? title;
  String? shortDescription;
  DiningCampaignCityConfigModel? city;
  List<String>? restaurant;
  String? image;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  List<CampaignTranslations>? translations;
  bool? status;
  String? id;
  final String locale;
  DiningCampaignConfigModel({this.title, this.shortDescription, this.city, this.restaurant, this.image, this.startDate, this.endDate, this.startTime, this.endTime, this.translations, this.status, this.id, required this.locale});

  DiningCampaignConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    title = json['title'];
    shortDescription = json['shortDescription'];
    city = json['city'] != null ? DiningCampaignCityConfigModel.fromJson(json['city'], locale) : null;
    restaurant = json['restaurant'].cast<String>();
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
      translations = <CampaignTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CampaignTranslations.fromJson(v));
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
    data['restaurant'] = restaurant;
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

class DiningCampaignCityConfigModel {
  String? id;
  String? name;
  String? slug;
  List<CityTranslations>? translations;
  final String locale;
  DiningCampaignCityConfigModel({this.id, this.name, this.slug, this.translations, required this.locale});

  DiningCampaignCityConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    if (json['translations'] != null) {
      translations = <CityTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CityTranslations.fromJson(v));
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
    data['slug'] = slug;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  CityTranslations({this.name, this.code, this.nativeName, this.value});

  CityTranslations.fromJson(Map<String, dynamic> json) {
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

class CampaignTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  CampaignTranslations({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  CampaignTranslations.fromJson(Map<String, dynamic> json) {
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
